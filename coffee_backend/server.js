const express = require("express");
const cors = require("cors");

const app = express();

// middleware
app.use(cors());
app.use(express.json());

// =========================
// ☕ COFFEE LIST API
// =========================
app.get("/api/coffees", (req, res) => {
  res.json([
    {
      id: 1,
      name: "Americano",
      type: "Espresso",
      price: 15000,
      image: "coffee1.jpg"
    },
    {
      id: 2,
      name: "Latte",
      type: "Latte",
      price: 18000,
      image: "coffee2.jpg"
    },
    {
      id: 3,
      name: "Cappuccino",
      type: "Cappuccino",
      price: 17000,
      image: "coffee3.jpg"
    },
    {
      id: 4,
      name: "Mocha",
      type: "Chocolate",
      price: 20000,
      image: "coffee4.jpg"
    }
  ]);
});

// =========================
// 🛒 ORDER CREATE API
// =========================
let orders = [];

app.post("/api/order", (req, res) => {
  const order = req.body;

  if (!order.name) {
    return res.status(400).json({
      message: "Order name required"
    });
  }

  const newOrder = {
    id: orders.length + 1,
    name: order.name,
    details: order.details,
    price: order.price || 0,
    createdAt: new Date()
  };

  orders.push(newOrder);

  res.status(201).json({
    message: "Order created successfully",
    order: newOrder
  });
});

// =========================
// 📦 GET ORDERS API
// =========================
app.get("/api/orders", (req, res) => {
  res.json(orders);
});

// =========================
// 🏠 HOME
// =========================
app.get("/", (req, res) => {
  res.send("☕ Coffee Shop API ажиллаж байна");
});

// =========================
// SERVER START
// =========================
const PORT = 3000;

app.listen(PORT, () => {
  console.log(`Server ажиллаж байна: http://localhost:${PORT}`);
});