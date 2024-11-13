const OTP = require("../models/otp.model");

const generateOtp = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

const createOtpForUser = async (userId) => {
  const otpCode = generateOtp();
  const expiresAt = Date.now() + 300000; // expire in 5 minute
  await OTP.create({ userId, otpCode, expiresAt });
  return otpCode;
};

const generateRandomString = (length = 10) => {
  const characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let randomString = "";

  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * characters.length);
    randomString += characters[randomIndex];
  }

  return randomString;
};

module.exports = {
  createOtpForUser,
  generateRandomString,
};
