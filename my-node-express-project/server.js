const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const WebSocket = require("ws"); // Import WebSocket
const app = express();
const db = require("./models/database");
const mealRoutes = require("./routes/mealRoutes");
const PORT = 3002;
const logger = require("./logger/logger");
app.use(cors());
app.use(bodyParser.json());

logger.info("Server started!");
app.listen(PORT, () => {
  logger.info(`Server is running on port ${PORT}`);
});

// WebSocket server setup
const wss = new WebSocket.Server({ port: 3001 }); // WebSocket server on port 3001

wss.on("connection", (ws) => {
  logger.info("Client connected via WebSocket");

  ws.on("close", () => {
    logger.warn("Client disconnected");
  });
});

// Broadcast function to notify clients
function broadcastChange(operation, data) {
  const message = JSON.stringify({ operation, data });
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message); // Send message to connected clients
    }
  });
}

// Pass the broadcast function to the route
app.use("/meals", mealRoutes(broadcastChange)); // Pass broadcastChange to mealRoutes

module.exports = app;

// // Function to delete all rows and insert two new values
// function resetDatabase() {
//   const deleteQuery = `DELETE FROM Meal`;
//   const insertQuery = `INSERT INTO Meal (name, type, calories, time) VALUES (?, ?, ?, ?)`;

//   // Delete all rows
//   db.run(deleteQuery, (err) => {
//     if (err) {
//       console.error("Error deleting rows:", err);
//       return;
//     }
//     console.log("All rows deleted.");

//     // Insert first meal
//     db.run(
//       insertQuery,
//       ["Pasta", "Lunch", 600, new Date().toISOString()],
//       function (err) {
//         if (err) {
//           console.error("Error inserting first meal:", err);
//           return;
//         }
//         console.log("First meal inserted.");
//       }
//     );

//     // Insert second meal
//     db.run(
//       insertQuery,
//       ["Salad", "Dinner", 300, new Date().toISOString()],
//       function (err) {
//         if (err) {
//           console.error("Error inserting second meal:", err);
//           return;
//         }
//         console.log("Second meal inserted.");
//       }
//     );
//   });
// }

// // Run the resetDatabase function once on server start
// resetDatabase();
