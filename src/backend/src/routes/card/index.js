"use strict";

const express = require("express");
const router = express.Router();
const CardController = require("../../controllers/card.controller");
const asyncHandler = require("express-async-handler");

router.get("/:deck_id", asyncHandler(CardController.getCardsByDeckId));

module.exports = router;
