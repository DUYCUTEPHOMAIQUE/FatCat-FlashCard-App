"use strict";

const { where } = require("sequelize");
const { NotFoundError } = require("../core/error.response");
const { Deck, Category, Card, User } = require("../models");
const ApiError = require("../utils/ApiError");

class DeckService {
  static async getAllDecks() {
    const decks = await Deck.findAll({ include: [{ model: Category, attributes: ["name"] }] });

    const data = decks.map(deck => ({
      id: deck.id,
      name: deck.name,
      description: deck.description,
      user_id: deck.user_id,
      issuer_id: deck.issuer_id,
      category_id: deck.category_id,
      deck_cards_count: deck.deck_cards_count,
      is_published: deck.is_published,
      category_name: deck.Category?.name,
      question_language: deck.question_language,
      answer_language: deck.answer_language,
      created_at: deck.createdAt,
      updated_at: deck.updatedAt,
    }));
    return data;
  }
  static async getDecksByCategoryName(categoryName) {
    const category = await Category.findOne({
      where: { name: categoryName },
    });
    if (!category) {
      throw new NotFoundError("Category not found");
    }
    return await Deck.findAll({
      where: { category_id: category.id },
      include: [{ model: Category, attributes: ["name"] }],
    });
  }
  //   static async getCardsByDeckId(deckId) {
  //     return await Card.findAll({
  //       where: { deck_id: deckId },
  //     });
  //   }
  //   static async getDeckById(deckId) {
  //     return await Deck.findByPk(deckId);
  //   }
  //   static async createDeck({
  //     user_id,
  //     name,
  //     description,
  //     category_id,
  //     is_published = false,
  //   }) {
  //     return await Deck.create({
  //       user_id,
  //       name,
  //       description,
  //       category_id,
  //       is_published,
  //     });
  //   }
  //   static async updateDeck(
  //     deckId,
  //     { name, description, category_name, is_published }
  //   ) {
  //     const updateFields = {};
  //     if (name) updateFields.name = name;
  //     if (description) updateFields.description = description;
  //     if (category_name) {
  //       const category = await Category.findOne({
  //         where: { name: category_name },
  //       });
  //       if (!category) throw new NotFoundError("Category not found");
  //       updateFields.category_id = category.id;
  //     }
  //     if (is_published !== undefined) updateFields.is_published = is_published;
  //     const updatedDeck = await Deck.update(updateFields, {
  //       where: { id: deckId },
  //     });
  //     if (!updatedDeck) throw new NotFoundError("Deck not found");
  //     return updatedDeck;
  //   }
  //   static async deleteDeck(deckId) {
  //     return await Deck.destroy({ where: { id: deckId } });
  //   }

  //duong lam

  // static getDecks = async ({userId, user}) => {
  //     const canEdit = userId === user.userId ? true : false;
  //     const deck = await Deck.findAll({
  //         where :{
  //             user_id: userId
  //         }
  //     })
  // }
  static getUserInfor = async (userId) => {
    const user = await User.findOne({
      where: {
        id: userId,
      },
    });
    return { username: user.name, avatar: user.avatar };
  };

  static createDeck = async ({ deckData }) => {
    const deck = await Deck.create(deckData);
    const userInfor = await this.getUserInfor(deck.user_id);
    return { deck, userInfor };
  };

  // copy a deck anf all card of that deck for userId. Issuer of new deck is also userId
  static createDeckByCopy = async ({ deckId, userId }) => {
    const queryJoin = await Deck.findAll({
      where: {
        id: deckId,
      },
      attributes: { exclude: ["id", "createdAt", "updatedAt"] },
      raw: true,

      include: [
        {
          model: Card,
          attributes: { exclude: ["id", "createdAt", "updatedAt"] },
          //required: true,
        },
        // {
        //   model: User,
        //   // where: {
        //   //   issuer_id: userId,
        //   // },
        //   required: true,
        //   attributes: { exclude: ["id", "createdAt", "updatedAt"] },
        // },
      ],
    });

    if (!queryJoin) throw new ApiError("Deck not found.", 404);

    const object = queryJoin[0];
    //if the user that want copy deck is not the same user create this deck -> check their id, and check deck publish or not at the same time
    if (object.issuer_id !== userId && !object.is_published)
      throw new ApiError("Access denied.", 403); // if deck.issuer_id === userId  not throw any error

    const deckData = {},
      cards = [];
    let count = 0;

    //copy deck
    for (const key in object) {
      if (count >= 9) break;
      deckData[key] = object[key];
      count++;
    }
    deckData.user_id = deckData.issuer_id = userId;

    //create deck with same data
    const newDeck = await Deck.create(deckData);
    const deckDataPlain = newDeck.get({ plain: true });
    delete deckDataPlain.createdAt;
    delete deckDataPlain.updatedAt;

    //copy card
    for (let data of queryJoin) {
      const card = {};
      card.deck_id = newDeck.id;
      card.question = data["Cards.question"];
      card.image = data["Cards.image"];
      card.answer = data["Cards.answer"];
      if (card.question && card.answer) cards.push(card);
    }

    //create cards
    let newCards = Array.isArray(cards) ? await Card.bulkCreate(cards) : {};
    newCards = newCards.map((card) => {
      const { createdAt, updatedAt, ...rest } = card.get({ plain: true });
      return rest;
    });
    return { deckCopy: deckDataPlain, cardsCopy: newCards };
  };

  static getDeckByDeckId = async ({ deckId }) => {
    const deck = await Deck.findOne({
      where: {
        id: deckId,
      },
    });

    const cards = await Card.findAll({
      where: {
        deck_id: deckId,
      },
    });
    return {
      deck,
      cards,
    };
  };

  static updateDeck = async ({ deckId, deckData, cards, userId }) => {
    const deck = await Deck.findByPk(deckId);
    if (!deck) throw new ApiError("Deck not found.", 404);
    if (userId !== deck.user_id) throw new ApiError("Access denied.", 403);
    if (deckData) {
      await deck.update(deckData, { validate: true });
      deck.save();
    }
    if (cards) {
      for (let card of cards) {
        if (card.deck_id && card.deck_id !== deckId)
          throw new ApiError("Access denied.", 403);
      }
      for (let card of cards) {
        if (card.delete) {
          await Card.destroy({
            where: {
              id: card.id,
            },
          });
        } else if (card.id) {
          //card.id not undefine
          await Card.update(
            {
              question: card.question,
              answer: card.answer,
              image_id: card.image,
            },
            {
              where: {
                id: card.id,
              },
              validate: true,
            }
          );
        } else {
          //card.id == undefine
          await Card.create({
            deck_id: deckId,
            question: card.question,
            answer: card.answer,
            image: card.image,
          });
        }
      }
    }
  };

  static deleteDeck = async ({ deckId, userId }) => {
    const deck = await Deck.findByPk(deckId);
    if (!deck) throw new ApiError("Deck not found.", 404);
    if (userId !== deck.user_id) throw new ApiError("Access denied.", 403);

    //delete deck
    await deck.destroy();

    //delete card
    await Card.destroy({
      where: {
        deck_id: deckId,
      },
    });
  };
}

module.exports = DeckService;
