/* const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/payment.controller');

router.post('/create-payment-intent', paymentController.createPaymentIntent);
//router.post('/webhook', express.raw({ type: 'application/json' }), paymentController.handleWebhook);

module.exports = router; */




const express = require('express');
const PaymentController = require('../controllers/payment.controller');
const paymentController = require('../controllers/payment.controller');

const router = express.Router();

router.post('/create-payment', PaymentController.createPayment);
router.post('/webhook/payos', PaymentController.handleWebhook); // Thêm route Webhook
//router.post('/webhook/payos', PaymentController.TesthandleWebhook);
//TesthandleWebhook
router.get('/payment-status', paymentController.getPaymentStatus); 
module.exports = router;