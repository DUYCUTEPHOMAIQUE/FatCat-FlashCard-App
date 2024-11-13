"use strict";

const TokenService = require("../services/token.service");
const { ForbiddenError } = require("../core/error.response");
const asyncHandler = require("express-async-handler");
const jwt = require("jsonwebtoken");
const Token = require("../models/token.model");
const ApiError = require("../utils/ApiError");
const HEADER = {
  AUTHORIZATION: "authorization",
};

const accessMiddleware = async (req, res, next) => {
  try {
    const refreshToken = req.headers[HEADER?.REFRESHTOKEN];
    const token = req.headers[HEADER?.AUTHORIZATION];

    if (!token) {
      return next(new ForbiddenError("Unauthorized"));
    }

    try {
      const decoded = TokenService.verifyAccessToken(token);
      req.user = decoded;
      req.refreshToken = refreshToken;
      req.accessToken = token;
      return next();
    } catch (tokenError) {
      if (tokenError.name === "TokenExpiredError" && refreshToken) {
        try {
          const newAccessToken = await TokenService.refreshAccessToken(
            refreshToken
          );
          req.accessToken = newAccessToken;
          req.refreshToken = refreshToken;
          return next();
        } catch (refreshError) {
          return next(new ForbiddenError("Invalid refresh token"));
        }
      } else {
        return next(new ForbiddenError("Invalid access token"));
      }
    }
  } catch (error) {
    return next(error);
  }
};

const authenticateToken = asyncHandler(async (req, res, next) => {
  const token = req.headers["authorization"];
  if (!token)
    throw new ApiError(
      "Access denied. Authorization token missing from request.",
      401
    );
  await jwt.verify(token, process.env.JWT_SECRET, async (err, decoded) => {
    if (err) {
      switch (err.name) {
        case "TokenExpiredError":
          throw new ApiError(err.message, 420, err.name);
        default:
          throw new ApiError(err.message, 421, err.name);
      }
    }
    const user = {
      userId: decoded.userId,
      email: decoded.email,
      role: decoded.role,
    };
    //check in database if token exist
    const findToken = await Token.findOne({
      where: {
        userId: user.userId,
      },
    });
    if (!findToken)
      throw new ApiError(
        "Access denied. No valid session token. Please re-authenticate.",
        402
      );
    req.user = user;
    req.accessToken = token;
    next();
  });
});
module.exports = {
  authenticateToken,
  accessMiddleware,
};
