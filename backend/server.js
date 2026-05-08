require('dotenv').config();

const express = require('express');
const cors = require('cors');
const twilio = require('twilio');

const app = express();

app.use(cors());
app.use(express.json());

const client = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);

// إرسال كود SMS
app.post('/auth/send-code', async (req, res) => {
  try {
    const { phone } = req.body;

    if (!phone) {
      return res.status(400).json({
        success: false,
        message: 'رقم الهاتف مطلوب',
      });
    }

    const verification = await client.verify.v2
      .services(process.env.TWILIO_VERIFY_SERVICE_SID)
      .verifications
      .create({
        to: phone,
        channel: 'whatsapp',
      });

    return res.status(200).json({
      success: true,
      status: verification.status,
      message: 'تم إرسال كود التحقق عبر واتساب',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// فحص كود SMS
app.post('/auth/check-code', async (req, res) => {
  try {
    const { phone, code, userType } = req.body;

    if (!phone || !code) {
      return res.status(400).json({
        success: false,
        message: 'رقم الهاتف والكود مطلوبان',
      });
    }

    const verificationCheck = await client.verify.v2
      .services(process.env.TWILIO_VERIFY_SERVICE_SID)
      .verificationChecks
      .create({
        to: phone,
        code: code,
      });

    if (verificationCheck.status === 'approved') {
      return res.status(200).json({
        success: true,
        verified: true,
        userType: userType,
        message: 'تم التحقق بنجاح',
      });
    }

    return res.status(400).json({
      success: false,
      verified: false,
      message: 'كود التحقق غير صحيح',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      verified: false,
      message: error.message,
    });
  }
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});