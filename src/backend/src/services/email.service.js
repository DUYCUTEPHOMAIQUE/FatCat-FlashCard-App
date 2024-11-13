const nodemailer = require("nodemailer");
require("dotenv").config();
const {
  VERIFICATION_EMAIL_TEMPLATE,
  PASSWORD_RESET_REQUEST_TEMPLATE,
  PASSWORD_RESET_SUCCESS_TEMPLATE,
} = require("../templates/index");

const transporter = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWORD,
  },
});
const sendVerificationMail = async (email, name, otpCode) => {
  const html = VERIFICATION_EMAIL_TEMPLATE.replace("{userName}", name)
    .replace("{verificationCode}", otpCode)
    .replace("{expirationTime}", 5)
    .replace("{appName}", "FatCat");
  await transporter.sendMail({
    from: '"FatCat" <service.dichotienloi@gmail.com>',
    to: email,
    subject: "Verify Your Account",
    html,
  });
};

const sendResetPasswordMail = async ({ email, name, newPassword }) => {
  const html = PASSWORD_RESET_REQUEST_TEMPLATE.replace("{User}", name)
    .replace("{Your_Temporary_Password}", newPassword)
    .replace("{Your Website Team}", "FatCat Team")
    .replace("{Your Website}", "FatCat");
  await transporter.sendMail({
    from: '"FatCat" <service.dichotienloi@gmail.com>',
    to: email,
    subject: "Reset Password",
    html,
  });
};

const sendSuccessResetPasswordEmail = async ({ email, name }) => {
  const html = PASSWORD_RESET_SUCCESS_TEMPLATE.replace("{User}", name)
    .replace("{Your Company}", "FatCat")
    .replace("{Your Company}", "FatCat");
  await transporter.sendMail({
    from: '"FatCat" <service.dichotienloi@gmail.com>',
    to: email,
    subject: "Password Changed Successfully",
    html,
  });
};

module.exports = {
  sendVerificationMail,
  sendResetPasswordMail,
  sendSuccessResetPasswordEmail,
};
