"use strict";

const User = require("../models/user.model");
const TokenService = require("./token.service");
const { BadRequestError, NotFoundError } = require("../core/error.response");
const { pick } = require("../utils");
const { token } = require("morgan");
const { password } = require("../config/database.config");
const {
  sendVerificationMail,
  sendResetPasswordMail,
  sendSuccessResetPasswordEmail,
} = require("./email.service");
const jwt = require("jsonwebtoken");
const Token = require("../models/token.model");
const { createOtpForUser, generateRandomString } = require("./otp.sevice");
const { where } = require("sequelize");
const OTP = require("../models/otp.model");
const ApiError = require("../utils/ApiError");
const { Op } = require("sequelize");

class AccessService {
  static register = async ({ email, password, name }) => {
    if (!email || !password || !name)
      throw new BadRequestError("Missing required fields.");

    const foundUser = await User.findOne({
      where: {
        email,
      },
    });
    if (foundUser)
      throw new BadRequestError(
        "This email address is already associated with another account."
      );

    const user = await User.create({
      email,
      password,
      name,
    });

    const otpCode = await createOtpForUser(user.id);

    //await sendVerificationMail(user.email, user.name, otpCode);

    return {
      ...pick({ object: user, keys: ["email", "name", "role_system"] }),
      otpCode,
    };
  };

  static verify_account = async ({ email, otpCode }) => {
    //find user
    const user = await User.findOne({
      where: {
        email,
      },
    });
    if (!user)
      throw new NotFoundError(
        "User not found. Please check the information and try again."
      );
    if (user.isVerified)
      throw new ApiError("Your account has already been verified.", 430);

    //find otp
    const otp = await OTP.findOne({
      where: {
        userId: user.id,
        otpCode,
      },
    });
    if (!otp)
      throw new ApiError(
        "The verification code is invalid. Please double-check and try again.",
        431
      );

    if (otp.expiresAt < Date.now())
      throw new ApiError(
        "The verification code has expired. Please request a new code.",
        432
      );

    otp.isUsed = true;
    await otp.save();

    user.isVerified = true;
    await user.save();

    const payload = {
      userId: user.id,
      email: user.email,
      role: user.role_system,
    };

    const accessToken = await TokenService.generateAccessToken(payload);
    await Token.create({
      userId: user.id,
      accessToken,
    });
    return {
      ...pick({ object: user, keys: ["email", "name", "role_system"] }),
      accessToken,
    };
  };

  static resend_code = async ({ email }) => {
    const user = await User.findOne({
      where: {
        email,
      },
    });
    if (!user)
      throw NotFoundError(
        "Email is not correct. Please check the information and try again."
      );
    if (user.isVerified)
      throw new ApiError("Your account has already been verified.", 430);
    const newOtpCode = await createOtpForUser(user.id);
    //await sendVerificationMail(user.email, user.name, newOtpCode);
    return { newOtpCode };
  };

  static login = async ({ email, password }) => {
    const user = await User.findOne({
      where: {
        email,
      },
    });
    if (!user) throw new BadRequestError("Email or password is not correct.");
    const comparePassword = await user.comparePassword(password);
    if (!comparePassword)
      throw new BadRequestError("Email or password is not correct.");
    if (!user.isVerified)
      throw new BadRequestError(
        "Your Email has not been verified. Please click on resend."
      );
    const payload = {
      userId: user.id,
      email: user.email,
      role: user.role_system,
    };

    const accessToken = await TokenService.generateAccessToken(payload);
    await Token.create({
      userId: user.id,
      accessToken,
    });
    return {
      ...pick({
        object: user,
        keys: ["email", "name", "role_system"],
      }),
      accessToken,
    };
  };

  static logout = async ({ userId, accessToken }) => {
    await Token.destroy({
      where: {
        userId,
        accessToken,
      },
    });
  };

  static logout_all_device = async ({ userId }) => {
    await Token.destroy({
      where: {
        userId,
      },
    });
  };

  static reset_password = async ({ email }) => {
    const user = await User.findOne({
      where: {
        email,
      },
    });

    if (!user)
      throw new NotFoundError(
        "User not found. Please check the information and try again."
      );
    //await this.logout_all_device({ userId: user.id });
    const newPassword = generateRandomString();
    user.password = newPassword;
    await user.save();
    //await sendResetPasswordMail({ email, name: user.name, newPassword });
    return { newPassword };
  };

  static change_password = async ({
    userId,
    oldPassword,
    newPassword,
    accessToken,
  }) => {
    const user = await User.findOne({
      where: {
        id: userId,
      },
    });
    if (!user)
      throw new NotFoundError(
        "User not found. Please check the information and try again."
      );
    const comparePassword = await user.comparePassword(oldPassword);
    if (!comparePassword)
      throw new ApiError(
        "Your password is not correct. Check and try again.",
        400
      );

    //logout other device
    await Token.destroy({
      where: {
        userId,
        accessToken: { [Op.ne]: accessToken },
      },
    });

    //save new password
    user.password = newPassword;
    await user.save();
    await sendSuccessResetPasswordEmail({ email: user.email, name: user.name });
  };
}
module.exports = AccessService;
