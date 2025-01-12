const express = require("express");
const mealController = require("../controllers/mealController");
const router = express.Router();

// Export the router with the broadcast function
module.exports = (broadcastChange) => {
  router.get("/", (req, res) => mealController.getAllMeals(req, res));

  router.get("/:id", (req, res) => mealController.getSpecificMeal(req, res));

  router.post("/", (req, res) =>
    mealController.addNewMeal(req, res, broadcastChange)
  );

  router.put("/:id", (req, res) =>
    mealController.updateMeal(req, res, broadcastChange)
  );

  router.delete("/:id", (req, res) =>
    mealController.deleteMeal(req, res, broadcastChange)
  );

  return router;
};
