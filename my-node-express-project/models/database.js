const sqlite3 = require("sqlite3").verbose();
const logger = require("../logger/logger");
const db = new sqlite3.Database("./meals.db", (err) => {
  if (err) {
    logger.error("Database opening error: ", err);
  } else {
    logger.info("Connected to the meals database.");
    db.run(
      `CREATE TABLE IF NOT EXISTS Meal (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                type TEXT NOT NULL,
                calories INTEGER,
                time TEXT NOT NULL
              )`
    );
  }
});
module.exports = db;
