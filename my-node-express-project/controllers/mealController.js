const db = require("../models/database");
const logger = require("../logger/logger");

// Get all meals
exports.getAllMeals = (req, res) => {
  db.all("SELECT * FROM Meal", (err, rows) => {
    if (err) {
      logger.error(`Failed to retrieve meals: ${err.message}`);
      res.status(400).json({ error: "Failed to retrieve meals" });
      return;
    }
    res.json(rows);
  });
  logger.info("Successfully retrieved all meals");
};

exports.getSpecificMeal = (req, res) => {
  const { id } = req.params;
  const sql = "SELECT * FROM Meal WHERE id = ?";

  db.all(sql, [id], (err, rows) => {
    if (err) {
      logger.error(`Failed to retrieve meal with id ${id}: ${err.message}`);
      res.status(400).json({ error: "Failed to retrieve meal" });
      return;
    }

    if (rows.length === 0) {
      logger.warn(`No meal found with id: ${id}`);
      res.status(404).json({ error: "Meal not found" });
      return;
    }

    logger.info(`Successfully retrieved meal with id: ${id}`);
    res.json(rows[0]);
  });
};

// Add a new meal
exports.addNewMeal = (req, res, broadcastChange) => {
  const { name, type, calories, time } = req.body;
  const sql = `INSERT INTO Meal (name, type, calories, time) VALUES (?, ?, ?, ?)`;
  db.run(sql, [name, type, calories, time], function (err) {
    if (err) {
      logger.error(`Failed to add new meal: ${err.message}`);
      res.status(400).json({ error: "Failed to add new meal" });
      return;
    }
    const newMeal = { id: this.lastID, name, type, calories, time };
    logger.info(`New meal added with ID ${this.lastID}`);
    broadcastChange("create", newMeal); // Notify clients of the new meal
    res.status(201).json(newMeal);
  });
};

// Update a meal
exports.updateMeal = (req, res, broadcastChange) => {
  const { id } = req.params;
  const { name, type, calories, time } = req.body;
  const sql = `UPDATE Meal SET name = ?, type = ?, calories = ?, time = ? WHERE id = ?`;
  db.run(sql, [name, type, calories, time, id], function (err) {
    if (err || this.changes === 0) {
      logger.error(`Failed to update meal ${err.message}`);
      res.status(500).json({ error: "Failed to update meal" });
    } else {
      const updatedMeal = { id, name, type, calories, time };
      logger.info(`Meal with ID ${id} was updated`);
      broadcastChange("update", updatedMeal); // Notify clients of the update
      res.status(200).json(updatedMeal);
    }
  });
};

// Delete a meal
exports.deleteMeal = (req, res, broadcastChange) => {
  const { id } = req.params;
  const sql = `DELETE FROM Meal WHERE id = ?`;
  db.run(sql, id, function (err) {
    if (err || this.changes === 0) {
      logger.error(`Failed to delete meal ${err.message}`);
      res.status(500).json({ error: "Failed to delete meal" });
    } else {
      logger.info(`Meal with ID ${id} was deleted`);
      broadcastChange("delete", { id }); // Notify clients of the deletion
      res.status(200).json({ id });
    }
  });
};
