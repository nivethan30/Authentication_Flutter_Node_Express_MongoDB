import { model, Schema, version } from "mongoose";

const userSchema = Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      trim: true,
      unique: true,
    },
    password: {
      type: String,
      required: true,
    },
  },
  {
    versionKey: false,
    collection: "users",
  }
);

const User = model("User", userSchema);

export default User;
