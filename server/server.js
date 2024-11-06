import express from "express";
import connectDB from "./config/db.js";
import authRouter from "./routes/authRoutes.js";
import cors from "cors";

const PORT = 3000;

const app = express();

app.use(cors());

app.use(express.json());

connectDB();

app.use(express.urlencoded({ extended: true }));

app.get("/", (req, res) => {
  res.send("Connected to Server");
});

app.use("/auth", authRouter);

app.use((req, res, next) => {
  res.status(404).json({
    message: `Endpoint ${req.url} with method ${req.method} not found.`,
    status: 404,
  });
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({
    message: "Something went wrong. Please try again later.",
    status: 500,
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});
