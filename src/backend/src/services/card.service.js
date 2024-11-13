"use strict";

const { Card } = require("../models");

class CardService {
    static async getCardsByDeckId({deckId}) {
        console.log(deckId+'===');
        return await Card.findAll({
            where: { deck_id: deckId }
        });
    }
}

module.exports = CardService;