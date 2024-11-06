import jwt from "jsonwebtoken";

const authMiddleware = {
  auth: (req, res, next) => {
    try {
      const token = req.header("auth_token");
      if (!token)
        return res.status(401).json({ msg: "No auth token, access denied" });

      const verified = jwt.verify(token, "Admin@123");
      if (!verified)
        return res
          .status(401)
          .json({ msg: "Token verification failed, authorization denied." });
      req.user = verified.id;
      req.token = token;
      next();
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  },
};

export const { auth } = authMiddleware;
