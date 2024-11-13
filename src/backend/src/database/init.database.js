const { Sequelize } = require("sequelize");
const databaseConfig = require("../config/database.config");

const sequelize = new Sequelize(databaseConfig);

try {
  sequelize.authenticate();
  console.log(databaseConfig.host);
  console.log("Connection has been established successfully.");
} catch (error) {
  console.error("Unable to connect to the database:", error);
}

module.exports = {
  sequelize,
};
