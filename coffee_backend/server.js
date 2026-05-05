const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

const app = express();

app.use(cors());
app.use(express.json());

// =========================
// 🟢 PostgreSQL холболт
// =========================
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "coffee_db",
  password: "1000",
  port: 5432,
});

// =========================
// ☕ ALL COFFEES
// =========================
app.get("/api/coffees", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT c.id, c.name, c.price, c.image,
             cat.name AS category
      FROM coffees c
      JOIN categories cat ON c.category_id = cat.id
      ORDER BY c.id DESC
    `);

    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Coffee авах алдаа" });
  }
});

// =========================
// 📂 GET BY CATEGORY
// =========================
app.get("/api/coffees/category/:name", async (req, res) => {
  const { name } = req.params;

  try {
    const result = await pool.query(`
      SELECT c.*, cat.name AS category
      FROM coffees c
      JOIN categories cat ON c.category_id = cat.id
      WHERE cat.name = $1
    `, [name]);

    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// =========================
// 🔍 SEARCH COFFEE
// =========================
app.get("/api/coffees/search/:text", async (req, res) => {
  const { text } = req.params;

  try {
    const result = await pool.query(`
      SELECT * FROM coffees
      WHERE LOWER(name) LIKE LOWER($1)
    `, [`%${text}%`]);

    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// =========================
// 🛒 CREATE ORDER
// =========================
app.post("/api/order", async (req, res) => {
  const { name, details, price } = req.body;

  if (!name) {
    return res.status(400).json({ error: "Нэр шаардлагатай" });
  }

  try {
    const result = await pool.query(
      `INSERT INTO orders (name, details, price)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [name, details, price]
    );

    res.status(201).json({
      message: "Амжилттай",
      order: result.rows[0],
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Order хадгалах алдаа" });
  }
});

// =========================
// 📦 GET ORDERS
// =========================
app.get("/api/orders", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM orders ORDER BY id DESC`
    );

    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// =========================
// 🗑 DELETE ORDER
// =========================
app.delete("/api/orders/:id", async (req, res) => {
  const { id } = req.params;

  try {
    await pool.query(`DELETE FROM orders WHERE id=$1`, [id]);

    res.json({ message: "Устгалаа" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// =========================
// 🏠 HOME
// =========================
app.get("/", (req, res) => {
  res.send("☕ Coffee API ажиллаж байна");
});

// =========================
// 🚀 START
// =========================
const PORT = 3000;

app.listen(PORT, () => {
  console.log(`🚀 http://localhost:${PORT}`);
});