"use strict";
require("dotenv").config();
const express = require("express");
const morgan = require("morgan");
const helmet = require("helmet");
const compression = require("compression");
const { sequelize } = require("./database/init.database");
const cors = require("cors");
const {
  User,
  Deck,
  Card,
  Image,
  Class,
  ClassMember,
  ClassDeck,
  Category,
  Token,
} = require("./models");
const seedAllData = require("./scripts/seedAllData");
const seedClassData = require("./scripts/seedClassData");

const app = express();

app.use(morgan("dev"));
app.use(helmet());
app.use(compression());
app.use(express.json());
app.use(cors());

//init database

sequelize
  .sync({ force: true })
  .then(async () => {
    console.log("All models were synchronized successfully.");
    await seedAllData();
    await seedClassData();
  })
  .catch((error) => {
    console.error("Error synchronizing models:", error);
  });

//init routes
app.use("/", require("./routes"));


//handle errors
app.use((req, res, next) => {
    const error = new Error("Not found");
    error.status = 404;
    next(error);
});

app.use((error, req, res, next) => {
    res.status(error.status || 500);
    res.json({
        status: error.status,
        code: error.code,
        message: error.message || "Internal Server Error",
        stack: error.stack,
    })
})

module.exports = app;
