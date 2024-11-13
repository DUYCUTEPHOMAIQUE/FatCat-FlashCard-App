const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");
const User = require("./user.model");
const Category = require("./category.model");

const Deck = sequelize.define(
  "Deck",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    user_id: {
      type: DataTypes.INTEGER,
      references: {
        model: User,
        key: "id",
      },
    },
    issuer_id: {
      type: DataTypes.INTEGER,
      references: {
        model: User,
        key: "id",
      },
      allowNull: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
    },
    category_id: {
      type: DataTypes.INTEGER,
      references: {
        model: Category,
        key: "id",
      },
    },
    is_published: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
    deck_cards_count: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
    },
    question_language: {
      type: DataTypes.TEXT,
      defaultValue: "en",
    },
    answer_language: {
      type: DataTypes.TEXT,
      defaultValue: "en",
    },
  },
  {
    tableName: "Decks",
    timestamps: true,
  }
);

module.exports = Deck;
