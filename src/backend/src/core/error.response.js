"use strict";

const { StatusCodes } = require("http-status-codes");

class ErrorResponse extends Error {
    constructor(message, status ) {
        super(message);
        this.status = status;
    }
}

class BadRequestError extends ErrorResponse {
    constructor(message = "Bad Request", statusCode = StatusCodes.BAD_REQUEST) {
        super(message, statusCode);
    }
}
class NotFoundError extends ErrorResponse {
    constructor(message = "Not Found", statusCode = StatusCodes.NOT_FOUND) {
        super(message, statusCode);
    }
}
class ConflictError extends ErrorResponse {
    constructor(message = "Conflict", statusCode = StatusCodes.CONFLICT) {
        super(message, statusCode);
    }
}
class ForbiddenError extends ErrorResponse {
    constructor(message = "Forbidden", statusCode = StatusCodes.FORBIDDEN) {
        super(message, statusCode);
    }
}


module.exports = { ErrorResponse, BadRequestError, NotFoundError, ConflictError, ForbiddenError };