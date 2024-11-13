// src/models/class_deck.model.js
const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");
const Class = require("./class.model");
const Deck = require("./deck.model");

const ClassDeck = sequelize.define(
  "ClassDeck",
  {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    class_id: {
      type: DataTypes.INTEGER,
      references: {
        model: Class,
        key: "id",
      },
    },
    deck_id: {
      type: DataTypes.INTEGER,
      references: {
        model: Deck,
        key: "id",
      },
    },
  },
  {
    tableName: "ClassDecks",
    timestamps: false,
  }
);

module.exports = ClassDeck;
