"use strict";

const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const AccessController = require("../../controllers/access.controller");
const { authenticateToken } = require("../../middlewares/auth.middleware");

router.post("/register", asyncHandler(AccessController.register));
router.post("/verify-account", asyncHandler(AccessController.verify_account));
router.post("/resend-code", asyncHandler(AccessController.resend_code));
router.post("/login", asyncHandler(AccessController.login));
router.post(
  "/logout",
  authenticateToken,
  asyncHandler(AccessController.logout)
);
router.post(
  "/logout-all-device",
  authenticateToken,
  asyncHandler(AccessController.logout_all_device)
);
router.post("/reset-password", asyncHandler(AccessController.reset_password));
router.post(
  "/change-password",
  authenticateToken,
  asyncHandler(AccessController.change_password)
);
module.exports = router;
