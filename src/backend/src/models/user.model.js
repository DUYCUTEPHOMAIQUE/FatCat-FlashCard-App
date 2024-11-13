const { DataTypes } = require("sequelize");
const { sequelize } = require("../database/init.database");
const bcrypt = require("bcrypt");

const User = sequelize.define(
  "User",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    role_system: {
      type: DataTypes.ENUM("user", "admin"),
      defaultValue: "user",
    },
    role_group: {
      type: DataTypes.ENUM("leader", "member"),
      defaultValue: "member",
    },
    status: {
      type: DataTypes.ENUM("active", "inactive"),
      defaultValue: "active",
    },
    streak_length: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
    },
    streak_start_at: {
      type: DataTypes.DATE,
    },
    score: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
    },
    streak_end_at: {
      type: DataTypes.DATE,
    },
    last_reviewed_at: {
      type: DataTypes.DATE,
    },
    isVerified: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    avatar: {
      type: DataTypes.BLOB("medium"),
      allowNull: true,
    },
  },
  {
    tableName: "Users",
    timestamps: true,
  }
);

User.beforeSave(async (user, options) => {
  if (user.changed("password")) {
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(user.password, salt);
  }
});

User.prototype.comparePassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

module.exports = User;
