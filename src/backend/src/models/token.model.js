const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");
const { add } = require("date-fns");
const User = require("./user.model");

const Token = sequelize.define(
  "Token",
  {
    userId: {
      type: DataTypes.INTEGER,
      references: {
        model: User,
        key: "id",
      },
    },
    accessToken: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    expiresAt: {
      type: DataTypes.DATE,
    },
  },
  {
    tableName: "Tokens",
    timestamps: true,
    hooks: {
      beforeCreate: (token) => {
        token.expiresAt = add(new Date(), { days: 90 }); // expire after 90day
      },
    },
  }
);

module.exports = Token;
