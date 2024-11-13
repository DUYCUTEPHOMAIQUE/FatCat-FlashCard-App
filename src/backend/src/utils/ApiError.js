class ApiError extends Error {
  constructor(message, statusCode, name = null) {
    super(message);
    this.name = name || this.constructor.name;
    this.status = statusCode;
  }
}

module.exports = ApiError;
