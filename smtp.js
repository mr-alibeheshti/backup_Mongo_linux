const dotenv = require("dotenv");
const nodemailer = require("nodemailer");

dotenv.config();

function configEmailService() {
  const MAIL_HOST = "process.env.MAIL_HOST";
  const MAIL_PORT = "process.env.MAIL_PORT";
  const MAIL_USER = "process.env.MAIL_USER";
  const MAIL_PASSWORD = "process.env.MAIL_PASSWORD";

  if (!MAIL_HOST || !MAIL_PORT || !MAIL_USER || !MAIL_PASSWORD) {
    throw new Error("One or more mail environment variables are missing.");
  }

  const transporter = nodemailer.createTransport({
    host: MAIL_HOST,
    port: MAIL_PORT,
    tls: true,
    auth: {
      user: MAIL_USER,
      pass: MAIL_PASSWORD,
    },
  } as nodemailer.TransportOptions);

  return transporter;
}

function sendEmail(email, subject, text) {
	const transporter = configEmailService();

	transporter
		.sendMail({
			from: `"Canny" <alibeheshti@technosit.ir>`,
			to: email,
			subject: subject,
			text: text,
		})
		.then(() => console.log("OK, Email has been sent."))
		.catch((error) => console.error("Error sending email:", error));
}
sendEmail("example@gmail.com","Backup faild","Hi,We have a problem uin backup operation pls check logs :)")

