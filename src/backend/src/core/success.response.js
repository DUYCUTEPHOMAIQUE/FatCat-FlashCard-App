"use strict";

const { StatusCodes } = require("http-status-codes");

class SuccessResponse {
  constructor({
    message,
    metadata = {},
    statusCode = StatusCodes.OK,
    reasonStatusCode = "OK",
  }) {
    this.message = message;
    this.statusCode = statusCode;
    this.reasonStatusCode = reasonStatusCode;
    this.metadata = metadata;
  }
  send(res, headers = {}) {
    return res.status(this.statusCode).json(this);
  }
}

module.exports = { SuccessResponse };
