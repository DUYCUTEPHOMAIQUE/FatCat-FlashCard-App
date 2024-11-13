// src/models/image.model.js
const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");

const Image = sequelize.define("Image", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    data: {
        type: DataTypes.BLOB('long'), 
    },
}, {
    tableName: "Images",
    timestamps: false,
});

module.exports = Image;