import mongoose from "mongoose";

const dbURL = "mongodb://localhost:27017";

const dbName = "Auth";

const connectDB = async () => {
  try {
    const connection = await mongoose.connect(dbURL, {
      dbName: dbName,
    });

    console.log(`Connected to MongoDb ${connection.connection.host}`);
  } catch (error) {
    console.log(`Error In Connecting With DB ${error}`);
     process.exit(1);
  }
};

export default connectDB;
