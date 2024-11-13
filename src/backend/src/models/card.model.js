// src/models/card.model.js
const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");
const User = require("./user.model");
const Deck = require("./deck.model");
const Image = require("./image.model");

const Card = sequelize.define(
  "Card",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    deck_id: {
      type: DataTypes.INTEGER,
      references: {
        model: Deck,
        key: "id",
      },
    },
    question: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    // image_id: {
    //   type: DataTypes.INTEGER,
    //   references: {
    //     model: Image,
    //     key: "id",
    //   },
    // },
    image: {
      type: DataTypes.BLOB,
      allowNull: true,
    },
    answer: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
  },
  {
    tableName: "Cards",
    timestamps: true,
  }
);

module.exports = Card;
