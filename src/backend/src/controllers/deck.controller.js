"use strict";

const { SuccessResponse } = require("../core/success.response");
const DeckService = require("../services/deck.service");

class DeckController {
  async getDecksByCategoryName(req, res, next) {
    new SuccessResponse({
      message: "Get decks by category name successfully",
      metadata: await DeckService.getDecksByCategoryName(
        req.query.categoryName
      ),
    }).send(res);
  }

  async createDeck(req, res, next) {
    const deckData = req.body;
    deckData.user_id = deckData.issuer_id = req.user.userId;
    return new SuccessResponse({
      message: "Create new deck successfully.",
      metadata: await DeckService.createDeck({ deckData }),
    }).send(res);
  }

  async createDeckByCopy(req, res, next) {
    const { deckId } = req.params;
    const { userId } = req.user;
    return new SuccessResponse({
      message: "Copy deck successfully.",
      metadata: await DeckService.createDeckByCopy({ deckId, userId }),
    }).send(res);
  }

  async updateDeck(req, res, next) {
    const { deck, cards } = req.body;
    const deckId = req.params.deckId;
    const { userId } = req.user;
    return new SuccessResponse({
      message: "Update deck successfully.",
      metadata: await DeckService.updateDeck({
        deckId,
        deckData: deck,
        cards,
        userId,
      }),
    }).send(res);
  }

  async deleteDeck(req, res, next) {
    const deckId = req.params.deckId;
    const { userId } = req.user;
    return new SuccessResponse({
      message: "Delete deck successfully.",
      metadata: await DeckService.deleteDeck({
        deckId,
        userId,
      }),
    }).send(res);
  }
  async getAllDecks(req, res, next) {
    return new SuccessResponse({
      message: "Get all decks successfully.",
      metadata: await DeckService.getAllDecks(),
    }).send(res);
  }
}

module.exports = new DeckController();
