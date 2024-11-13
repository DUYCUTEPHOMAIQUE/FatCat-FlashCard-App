// src/models/category.model.js
const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");

const Category = sequelize.define("Category", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
}, {
    tableName: "Categories",
    timestamps: true,
});

module.exports = Category;