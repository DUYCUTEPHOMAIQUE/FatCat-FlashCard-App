"use strict";

const jwt = require("jsonwebtoken");
const { pick } = require("../utils");
const ApiError = require("../utils/ApiError");

class TokenService {
  // static async generateRefreshToken(payload) {
  //   return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "90d" });
  // }

  static async generateAccessToken(payload) {
    return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "90d" });
  }

  // static async verifyRefreshToken(token) {
  //   return jwt.verify(token, process.env.JWT_SECRET);
  // }

  static verifyAccessToken(token) {
    return jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        switch (err.name) {
          case "TokenExpiredError":
            throw new ApiError(err.message, 420, err.name);
          default:
            throw new ApiError(err.message, 421);
        }
      }
    });
  }
  // static async refreshAccessToken(refreshToken) {
  //   const decoded = await this.verifyRefreshToken(refreshToken);
  //   if (!decoded) {
  //     throw new ForbiddenError("Unauthorized");
  //   }
  //   const payload = pick({
  //     object: decoded,
  //     keys: ["id", "email", "role_system"],
  //   });
  //   const accessToken = await this.generateAccessToken(payload);
  //   return accessToken;
  // }
}

module.exports = TokenService;
