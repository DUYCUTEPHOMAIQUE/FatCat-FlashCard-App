"use strict";

const { SuccessResponse } = require("../core/success.response");
const CardService = require("../services/card.service");

class CardController {
    static async getCardsByDeckId(req, res, next) {
        new SuccessResponse({
            message: "Get cards by deck id successfully",
            metadata: await CardService.getCardsByDeckId({ deckId: req.params.deck_id})
        }).send(res);
    }
}

module.exports = CardController;
