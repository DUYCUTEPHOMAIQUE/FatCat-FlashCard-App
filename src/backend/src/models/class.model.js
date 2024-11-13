// src/models/class.model.js
const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");
const User = require("./user.model");

const Class = sequelize.define("Class", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    description: {
        type: DataTypes.TEXT,
    },
    host_user_id: {
        type: DataTypes.INTEGER,
        references: {
            model: User,
            key: 'id',
        },
    },
    member_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
    },
    code_invite: {
        type: DataTypes.STRING,
    },
}, {
    tableName: "Classes",
    timestamps: true,
});

module.exports = Class;