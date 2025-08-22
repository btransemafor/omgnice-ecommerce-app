const payOS = require("../utils/payos");
const orderService = require('../services/order.services');
const {db} = require('../models/index');
class PaymentController {
  async createPayment(req, res) {
  try {
    const user_id = req.user.id;
    const orderCode = Number(String(Date.now()).slice(-6));

    req.body.orderInfo.user_id = user_id;
    req.body.orderInfo.payos_order_code = orderCode;

    const { orderInfo, products } = req.body;

    if (!orderInfo || !products || products.length === 0) {
      return res.status(400).json({ error: "Thiếu thông tin đơn hàng" });
    }

    const amount = Math.round(orderInfo.orderTotal);

    // Bắt lỗi khi tạo đơn hàng
    try {
      await orderService.createOtherOrder(orderInfo, products);
    } catch (err) {
      console.error("Lỗi khi tạo đơn hàng:", err.message);
      return res.status(500).json({ error: "Lỗi khi tạo đơn hàng", detail: err.message });
    }

    const paymentBody = {
      orderCode,
      amount,
      description: "Thanh toán đơn hàng",
      returnUrl:
          "https://c013-2401-d800-841-8b64-c5f2-1250-e09b-a53b.ngrok-free.app/return",
        cancelUrl:
          "https://c013-2401-d800-841-8b64-c5f2-1250-e09b-a53b.ngrok-free.app/cancel",
      metadata: {
        user_id: orderInfo.user_id,
        address_id: orderInfo.address_id,
        shipping_method_id: orderInfo.shipping_method_id,
      },
    };
      // Bước 2: Tìm đơn hàng theo mã PayOS
    const order = await orderService.findOrderByPayosCode(orderCode);


    const paymentLink = await payOS.createPaymentLink(paymentBody);

    return res.json({
      message: "Tạo liên kết thanh toán thành công",
      checkoutUrl: paymentLink.checkoutUrl,
      orderCode: paymentLink.orderCode,
      orderId: order.id, 
      qrCode: paymentLink.qrCode,
    });
  } catch (error) {
    console.error("Error creating payment link:", error);
    return res.status(500).json({
      error: "Lỗi khi tạo link thanh toán",
      details: error.message,
    });
  }
}

async handleWebhook(req, res) {
  try {
    // Bước 1: Xác thực webhook từ PayOS
    const webhookData = payOS.verifyPaymentWebhookData(req.body);
    console.log("Dữ liệu webhook:", webhookData);

    const orderCode = webhookData.orderCode;
    if (!orderCode) {
      return res.status(400).json({ error: "Thiếu orderCode trong dữ liệu webhook" });
    }

    // Bước 2: Tìm đơn hàng theo mã PayOS
    const order = await orderService.findOrderByPayosCode(orderCode);

    if (!order) {
      return res.status(404).json({ error: `Không tìm thấy đơn hàng với mã PayOS: ${orderCode}` });
    }

    // Bước 3: Kiểm tra nếu đã thanh toán rồi thì bỏ qua
    if (order.paymentStatus === true) {
      console.log("Đơn hàng đã được thanh toán, bỏ qua...");
      return res.status(200).json({ message: "Đơn hàng đã được xử lý trước đó" });
    }

    // Bước 4: Cập nhật trạng thái đơn hàng
    await orderService.updateOrderStatus(order.id, {
      paymentStatus: true,
      paidAt: new Date(),
    });

    console.log("Đã cập nhật trạng thái thanh toán cho đơn:", order.id);

    return res.status(200).json({
      message: "Webhook xử lý thành công",
      orderId: order.id,
    });
  } catch (err) {
    console.error("❌ Lỗi xử lý webhook:", err.message);
    return res.status(400).json({ error: "Webhook không hợp lệ hoặc xử lý thất bại" });
  }
}


 // GET /api/payment-status?orderId=ORD-xxxxx
  async getPaymentStatus(req, res) {
    try {
      const { orderId } = req.query;

      if (!orderId) {
        return res.status(400).json({ error: 'Thiếu orderId trong query params' });
      }

      const order = await db.order.findOne({
        where: { id: orderId },
        attributes: ['id', 'paymentStatus', 'orderStatus', 'payos_order_code', 'paidAt']
      });

      if (!order) {
        return res.status(404).json({ error: 'Không tìm thấy đơn hàng' });
      }

      return res.json({
        success: true,
        message: 'Trạng thái đơn hàng đã được lấy thành công',
        data: {
          orderId: order.id,
          paymentStatus: order.paymentStatus,
       //   orderStatus: order.orderStatus,
        //  payosOrderCode: order.payos_order_code,
        //  paymentDate: order.paymentDate,
        },
      });
    } catch (err) {
      console.error('Lỗi khi lấy trạng thái thanh toán:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ', details: err.message });
    }
  }
async TesthandleWebhook(req, res) {
  try {
    //  Bước 1: Lấy dữ liệu gốc từ PayOS
    const webhookData = req.body;
    console.log("📥 Dữ liệu webhook (PayOS gửi mẫu):", webhookData);

    const orderCode = String(webhookData.orderCode || '');

    //  Bước 2: Nếu là test mẫu từ PayOS (mã test hoặc không khớp hệ thống)
    if (orderCode.startsWith('123') || orderCode === '123') {
      console.log('🚨 Đây là dữ liệu webhook test từ PayOS — bỏ qua xử lý DB.');
      return res.status(200).json({
        message: 'Webhook test từ PayOS đã nhận thành công',
        test: true,
        orderCode,
      });
    }

    // 🛑 Không thực hiện kiểm tra DB nếu là webhook test
    // 👉 Nếu bạn vẫn muốn xử lý order thật bên dưới, giữ lại đoạn sau:
    /*
    const order = await orderService.findOrderByPayosCode(orderCode);
    if (!order) {
      return res.status(404).json({ error: `Không tìm thấy đơn hàng: ${orderCode}` });
    }

    if (order.paymentStatus === true) {
      return res.status(200).json({ message: "Đã xử lý rồi" });
    }

    await orderService.updateOrderStatus(order.id, {
      paymentStatus: true,
      paidAt: new Date(),
    });
    */

    return res.status(200).json({
      message: "Webhook mẫu từ PayOS đã được ghi nhận (no-op)",
      orderCode,
    });
  } catch (err) {
    console.error("❌ Lỗi khi xử lý webhook:", err.message);
    return res.status(400).json({
      error: "Webhook không hợp lệ hoặc xử lý thất bại",
      detail: err.message,
    });
  }
}






}

module.exports = new PaymentController();
