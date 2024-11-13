const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");
const User = require("./user.model");
const ClassModel = require("./class.model");

const ClassMember = sequelize.define("ClassMember", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    user_id: {
        type: DataTypes.INTEGER,
        references: {
            model: User,
            key: 'id',
        },
    },
    class_id: {
        type: DataTypes.INTEGER,
        references: {
            model: ClassModel,
            key: 'id',
        },
    },
    role: {
        type: DataTypes.STRING,
        defaultValue: "member",
    },
    joined_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
    },
}, {
    tableName: "ClassMembers",
    timestamps: false,
});

module.exports = ClassMember;