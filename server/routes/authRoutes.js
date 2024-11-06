import { Router } from "express";
import {
  login,
  signUp,
  getUserData,
  forgotPassword,
  resetPassword,
} from "../controllers/authController.js";

const authRouter = Router();

authRouter.post("/login", login);

authRouter.post("/signUp", signUp);

authRouter.get("/getUserData", getUserData);

authRouter.post("/forgotPassword", forgotPassword);

authRouter.post("/resetPassword", resetPassword);

export default authRouter;
