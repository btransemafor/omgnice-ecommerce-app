const  emailService  = require("../services/email.services");
const multer = require("multer");
const upload = multer(); // Sử dụng bộ nhớ RAM, không lưu file

const sendContact = async (req, res) => {
  const formData = {
    fullname: req.body.fullName,
    email: req.body.email,
    phoneNumber: req.body.phoneNumber, 
    subject: req.body.subject, 
    message: req.body.message,
    attachment: req.file, // multer sẽ thêm file vào đây
  };

  console.log(formData)

  emailService.sendContact(formData, (error, result) => {
    if (error) {
      return res
        .status(500)
        .json({ success: false, message: "Failed to send email", error });
    }

    return res.json({ success: true, message: "Email sent successfully" });
  });
};


module.exports = 
{
    sendContact, 
}


