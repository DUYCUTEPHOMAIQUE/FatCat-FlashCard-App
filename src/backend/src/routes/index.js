const express = require("express");
const router = express.Router();
const { authenticateToken } = require("../middlewares/auth.middleware");

router.get("/v1/api", (req, res) => {
  res.status(200).json({
    message: "Welcome to the API",
  });
});

router.use("/v1/api/deck", require("./deck/index"));
router.use("/v1/api/card", require("./card/index"));
router.use("/v1/api/access", require("./access/index"));
router.use("/v1/api", require("./verify/index"));
router.use("/v1/api/class", authenticateToken, require("./class/index"));


module.exports = router;
