import { createTransport } from "nodemailer";
import dotenv from "dotenv";
dotenv.config();

class Mailer {
  constructor() {
    this.transporter = createTransport({
      service: "gmail",
      auth: {
        user: process.env.EMAIL_ID,
        pass: process.env.EMAIL_PASS_KEY,
      },
    });
  }

  async sendOtpEmail(toEmail, otp) {
    const mailOptions = {
      from: process.env.EMAIL_ID,
      to: toEmail,
      subject: "Password Reset OTP",
      text: `Your OTP for resetting your password is: ${otp}. It will expire in 15 minutes.`,
    };

    try {
      const info = await this.transporter.sendMail(mailOptions);
      console.log("Email sent: " + info.response);
      return true;
    } catch (err) {
      console.error("Error sending OTP email: ", err.message);
      return false;
    }
  }
}

const mailer = new Mailer();

export default mailer;
