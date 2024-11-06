import User from "../model/user.js";
import { auth } from "../middleware/authMiddleware.js";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import crypto from "crypto";
import mailer from "../utils/mailer.js";

const authController = {
  login: async (req, res) => {
    try {
      const { email, password } = req.body;
      const user = await User.findOne({ email });
      if (!user) {
        return res
          .status(401)
          .json({ msg: "User with this email does not exist!" });
      }
      const isMatch = await bcryptjs.compare(password, user.password);
      if (!isMatch) {
        return res.status(401).json({ msg: "Incorrect password." });
      }
      const token = jwt.sign({ id: user._id }, "Admin@123");
      res.status(200).json({ token, ...user._doc });
    } catch (error) {
      console.log(error);

      res.status(500).send({ error: error.message });
    }
  },

  signUp: async (req, res) => {
    try {
      const { email, password, name } = req.body;
      const userExists = await User.findOne({ email });
      if (userExists) {
        res.status(400).json({ msg: "User with same email already exists!" });
      }
      const hashedPassword = await bcryptjs.hash(password, 8);

      const newUser = new User({
        email,
        password: hashedPassword,
        name,
      });

      const user = await newUser.save();
      if (user) {
        res.send(user);
      } else {
        res.status(400).json({ msg: "Invalid user data" });
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  getUserData: async (req, res) => {
    auth(req, res, async () => {
      try {
        const user = await User.findById(req.user);
        res.json({ ...user._doc, token: req.token });
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    });
  },

  forgotPassword: async (req, res) => {
    try {
      const { email } = req.body;
      const user = await User.findOne({ email });

      if (!user) {
        return res
          .status(404)
          .json({ msg: "User with this email does not exist!" });
      }

      const otp = crypto.randomInt(100000, 999999).toString();

      const emailSent = await mailer.sendOtpEmail(user.email, otp);

      if (!emailSent) {
        return res.status(500).json({ msg: "Error sending OTP email." });
      }

      res.status(200).json({
        msg: "OTP sent to your email address.",
        otp: otp,
      });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: error.message });
    }
  },

  resetPassword: async (req, res) => {
    try {
      const { email, newPassword } = req.body;

      const user = await User.findOne({ email });

      if (!user) {
        return res
          .status(404)
          .json({ msg: "User with this email does not exist!" });
      }

      const hashedPassword = await bcryptjs.hash(newPassword, 8);

      user.password = hashedPassword;
      await user.save();

      res.status(200).json({ msg: "Password successfully reset!" });
    } catch (error) {
      console.log(error);
      res.status(500).json({ error: error.message });
    }
  },
};

export const { login, signUp, getUserData, forgotPassword, resetPassword } =
  authController;
