const { db } = require("../models/index");
const notificationService = require("./notifications.services");
const promotionService = require("./promotion.services");
function calculatePoints(orderTotal) {
  return Math.floor(orderTotal / 10000); // 1 điểm mỗi 10k
}

const getAllOrder = async (user_id, callback) => {
  try {
    const orders = await db.order.findAll({
      where: { user_id },
      include: [
        {
          model: db.shipping_method,
          as: "shippingMethod",
          attributes: ["name_shipping_method", "price"],
        },
        {
          model: db.promotion,
          as: "promotion",
          attributes: ["id", "code"],
        },
        {
          model: db.order_line,
          as: "orderLines",
          attributes: [
            "product_id",
            "variant_id",
            "quantity",
            "price",
            "note",
            "id",
            "is_review",
          ],
          include: [
            {
              model: db.product,
              as: "product",
              attributes: ["name_product", "imageUrl"],
            },
            {
              model: db.variant,
              as: "variant",
              attributes: ["id", "variant_name"],
            },
          ],
        },
        {
          model: db.userAddress,
          as: "userAddress",
          include: [
            {
              model: db.address,
              as: "address",
            },
          ],
        },
      ],
    });

    const transformed = orders.map((order) => {
      const o = order.get({ plain: true });

      return {
        id: o.id,
        userId: o.user_id,
        orderStatus: o.orderStatus,
        orderTotal: o.orderTotal,
        shipping_fee: o.shipping_fee,
        address: o.userAddress, // lấy trực tiếp từ include
        payment_method: o.payment_method,
        shippingMethod: o.shippingMethod?.name_shipping_method ?? "",
        promotionCode: o.promotion?.code ?? "",
        promotionDiscount: o.discount_amount,
        orderDate: o.orderDate,
        updatedAt: o.updatedAt,
        deliveredAt: o.deliveryCompletedAt,
        paidAt: o.paidAt,
        paymentStatus: o.paymentStatus,
        notes: o.notes ?? "",
        items: o.orderLines.map((line) => ({
          isReview: line.is_review,
          order_line_id: line.id,
          productName: line.product?.name_product ?? "",
          productId: line.product_id,
          thumbnail: line.product?.imageUrl ?? "",
          variantId: line.variant_id,
          variantName: line.variant?.variant_name ?? "",
          quantity: line.quantity,
          price: line.price,

          note: line.note ?? "",
        })),
      };
    });

    console.log(transformed);

    callback(null, transformed);
  } catch (error) {
    callback(error);
  }
};
// services/order.service.js
const getOrderDetail = async (userId, orderId) => {
  const order = await db.order.findOne({
    where: {
      id: orderId,
      user_id: userId,
    },
    include: [
      {
        model: db.shipping_method,
        as: "shippingMethod",
        attributes: ["name_shipping_method"],
      },
      {
        model: db.promotion,
        as: "promotion",
        attributes: ["code"],
      },
      {
        model: db.order_line,
        as: "orderLines",
        attributes: ["product_id", "variant_id", "quantity", "price", "note", 'id'],
        include: [
          {
            model: db.product,
            as: "product",
            attributes: ["name_product", "imageUrl"],
          },
          {
            model: db.variant,
            as: "variant",
            attributes: ["id", "variant_name"],
          },
        ],
      },
    ],
  });

  const address = await db.userAddress.findOne({
    where: { user_id: userId, id: order.address_id },
    include: [
      {
        model: db.address,
        as: "address",
      },
    ],
    // order: [['createdAt', 'DESC']],
  });

  if (!order) return null;

  const plain = order.get({ plain: true });

  return {
    id: plain.id,
    code: plain.code,
    deliveryFee: plain.shipping_fee,
    status: plain.orderStatus,
    isReview: plain.is_review,
    orderDate: plain.orderDate,
    deliveryCompleted: plain.deliveryCompletedAt ?? null,
    delivery_time_slot: plain.delivery_time_slot ?? "",
    total: plain.orderTotal,
    address: address,
    subtotal: plain.subTotal,
    paidAt: plain.paidAt,
    paymentStatus: plain.paymentStatus,
    promotionDiscount: plain.discount_amount,
    paymentMethod: plain.payment_method,
    shippingMethod: plain.shippingMethod?.name_shipping_method ?? "",
    receiver: {
      name: plain.receiver_name,
      phone: plain.receiver_phone,
      address: plain.receiver_address,
    },
    items: plain.orderLines.map((item) => ({
      product_id: item.product_id,
      variant_id: item.variant_id,
      order_line_id: item.id, 
      name: item.product?.name_product ?? "",
      thumbnail: item.product?.imageUrl ?? "",
      quantity: item.quantity,
      price: item.price,
      variantName: item.variant?.variant_name ?? "",
      note: item.note ?? "",
    })),
  };
};

const createOrder = async (orderInfo, products, callback) => {
  try {
    const {
      user_id,
      address_id,
      shipping_method_id,
      shipping_fee,
      discountAmount,
      promotion_id,
      orderTotal,
      note,
      payment_method,
      delivery_time_slot,
      orderDate,
      payos_order_code,
    } = orderInfo;

    console.log(orderInfo);

    // Transaction để đảm bảo toàn vẹn dữ liệu
    const transaction = await db.sequelize.transaction();

    try {
      if (!products || products.length === 0) {
        return callback({
          success: false,
          message: "Danh sách sản phẩm (`products`) không được bỏ trống!",
        });
      }

      // Tạo đơn hàng
      const order = await db.order.create(
        {
          user_id,
          address_id,
          shipping_method_id,
          shipping_fee,
          orderTotal,
          promotion_id: promotion_id || null,
          discount_amount: discountAmount || 0,
          notes: note || null,
          payment_method,
          orderDate,
          deliveryCompletedAt: null,
          delivery_time_slot: delivery_time_slot || null,
          paymentStatus: false,
          orderStatus: "pending",
          payos_order_code: payos_order_code || null,
        },
        { transaction }
      );

      const orderId = order.id;

      // Tạo order_line cho từng sản phẩm
      for (const product of products) {
        const { product_id, variant_id, quantity, price, note } = product;

        if (!product_id || !quantity || !price) {
          await transaction.rollback();
          return callback({
            success: false,
            message:
              "Thiếu dữ liệu sản phẩm! Phải bao gồm: product_id, quantity, price.",
          });
        }

        await db.order_line.create(
          {
            order_id: orderId,
            product_id,
            variant_id: variant_id || null,
            quantity,
            price,
            note: note || null,
          },
          { transaction }
        );

        await db.product.increment("soldQuantity", {
          by: quantity,
          where: { id: product_id },
          transaction,
        });
      }

      // --- Điểm thưởng ---
      const user = await db.user.findByPk(user_id, { transaction });

      if (!user) {
        throw new Error("User not found");
      }

      const currentPoint = user.point || 0;
      const earnedPoint = Math.floor(orderTotal / 10000);
      const updatedPoint = currentPoint + earnedPoint;

      await db.user.update(
        { point: updatedPoint },
        { where: { id: user_id }, transaction }
      );

      // Ghi log tích điểm (nếu bạn có bảng user_point_logs)
      await db.user_point_log?.create?.(
        {
          userId: user_id,
          points: earnedPoint,
          reason: `Tích điểm đơn hàng #${orderId}`,
        },
        { transaction }
      );

      // Xóa promotion khỏi user nếu có promotion_id
      if (promotion_id) {
        // Kiểm tra xem promotion có tồn tại không
        const promotion = await db.promotion.findOne({
          where: { id: promotion_id },
          transaction,
        });

        if (!promotion) {
          await transaction.rollback();
          return callback({
            success: false,
            message: "Promotion Not Found",
          });
        }

        // Kiểm tra xem user có lưu promotion này không
        const userPromotion = await db.userPromotion.findOne({
          where: { user_id, promotion_id },
          transaction,
        });

        if (userPromotion) {
          // Giảm used_count
          if (promotion.used_count > 0) {
            await db.promotion.decrement("used_count", {
              where: { id: promotion_id },
              transaction,
            });
          }

          // Xóa bản ghi userPromotion
          await db.userPromotion.destroy({
            where: { user_id, promotion_id },
            transaction,
          });
        }
      }

      // Cuối cùng: COMMIT nếu không lỗi
      await transaction.commit();

      // Gửi thông báo hệ thống khi tạo đơn hàng thành công
      notificationService.createNotification(
        {
          user_id: user.id,
          title: "Order Placed Successfully",
          message: `Your order ${orderId} has been placed successfully. We’ll notify you once it’s out for delivery.`,
          type: "order",
        },
        (err) => {
          if (err) {
            console.error("Lỗi khi gửi thông báo đơn hàng:", err);
          }
        }
      );

      // Tao thong bao cho admin

      // Gửi thông báo cho admin khi tạo đơn hàng thành công
      notificationService.createNotiForAdmin(
        {
          title: "New Order Placed",
          message: `A new order ${orderId} has been placed successfully. Please check the details.`,
          type: "order",
        },
        (err) => {
          if (err) {
            console.error("Lỗi khi gửi thông báo đơn hàng cho admin:", err);
          }
        }
      );

      return callback(null, {
        success: true,
        message: "Tạo đơn hàng thành công!",
        data: order,
      });
    } catch (error) {
      await transaction.rollback();
      return callback({
        success: false,
        message: "Lỗi khi tạo đơn hàng!",
        error: error.message,
      });
    }
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi máy chủ!",
      error: error.message,
    });
  }
};

exports.getOrdersByStatus = async (userId, status) => {
  const orders = await db.order.findAll({
    where: {
      user_id: userId,
      orderStatus: status,
    },
    order: [["createdAt", "DESC"]],
    include: [
      {
        model: db.order_line,
        as: "orderLines",
        include: [
          {
            model: db.product,
            as: "product",
            attributes: ["name_product", "imageUrl"],
          },
        ],
      },
    ],
  });

  return orders.map((order) => {
    const plain = order.get({ plain: true });
    return {
      id: plain.id,
      orderDate: plain.createdAt,
      status: plain.orderStatus,
      code: plain.code,
      total: plain.orderTotal,
      itemCount: plain.orderLines.length,
      items: plain.orderLines.map((item) => ({
        name: item.product.name_product,
        thumbnail: item.product.imageUrl,
        quantity: item.quantity,
        price: item.price,
        size: item.size,
        note: item.note,
      })),
    };
  });
};

const createOtherOrder = async (orderInfo, products) => {
  const {
    user_id,
    address_id,
    shipping_method_id,
    shipping_fee,
    discountAmount,
    promotion_id,
    orderTotal,
    note,
    payment_method,
    delivery_time_slot,
    orderDate,
    payos_order_code,
  } = orderInfo;

  const transaction = await db.sequelize.transaction({
    isolationLevel: db.Sequelize.Transaction.ISOLATION_LEVELS.SERIALIZABLE, // Stricter isolation level
  });

  try {
    if (!products || products.length === 0) {
      throw new Error("Danh sách sản phẩm (`products`) không được bỏ trống!");
    }

    // Step 1: Validate payos_order_code uniqueness (if applicable)
    if (payos_order_code) {
      const existingOrder = await db.order.findOne({
        where: { payos_order_code },
        transaction,
      });
      if (existingOrder) {
        throw new Error("Mã PayOS (`payos_order_code`) đã tồn tại!");
      }
    }

    // Step 2: Check stock availability and lock product rows
    for (const product of products) {
      const { product_id, quantity } = product;

      if (!product_id || !quantity) {
        throw new Error("Thiếu dữ liệu sản phẩm!");
      }

      // Lock the product row to prevent concurrent updates
      const productRecord = await db.product.findByPk(product_id, {
        lock: transaction.LOCK.UPDATE, // Row-level lock
        transaction,
      });

      if (!productRecord) {
        throw new Error(`Sản phẩm với ID ${product_id} không tồn tại!`);
      }

      // Assuming you have a stock column in the product table
    }

    // Step 3: Create the order
    const order = await db.order.create(
      {
        user_id,
        address_id,
        shipping_method_id,
        shipping_fee,
        orderTotal,
        promotion_id: promotion_id || null,
        discount_amount: discountAmount || 0,
        notes: note || null,
        payment_method,
        orderDate,
        deliveryCompletedAt: null,
        delivery_time_slot: delivery_time_slot || null,
        paymentStatus: false,
        orderStatus: "pending",
        payos_order_code: payos_order_code || null,
      },
      { transaction }
    );

    const orderId = order.id;

    // Step 4: Create order lines and update soldQuantity
    for (const product of products) {
      const { product_id, variant_id, quantity, price, note } = product;

      // Create order line
      await db.order_line.create(
        {
          order_id: orderId,
          product_id,
          variant_id: variant_id || null,
          quantity,
          price,
          note: note || null,
        },
        { transaction }
      );

      console.log(`CAC ITME TRONG ORDER ${product}`);

      // Update soldQuantity (already locked, so no race condition)
      await db.product.increment("soldQuantity", {
        by: quantity,
        where: { id: product_id },
        transaction,
      });
    }

    // --- Điểm thưởng ---
    const user = await db.user.findByPk(user_id, { transaction });

    if (!user) {
      throw new Error("User not found");
    }

    const currentPoint = user.point || 0;
    const earnedPoint = Math.floor(orderTotal / 10000);
    const updatedPoint = currentPoint + earnedPoint;

    await db.user.update(
      { point: updatedPoint },
      { where: { id: user_id }, transaction }
    );

    // Step 5: Commit the transaction
    await transaction.commit();
    // Gửi thông báo hệ thống khi tạo đơn hàng thành công
    notificationService.createNotification(
      {
        user_id: user.id,
        title: "Order Placed Successfully",
        message: `Your order ${orderId} has been placed successfully. We’ll notify you once it’s out for delivery.`,
        type: "order",
      },
      (err) => {
        if (err) {
          console.error("Lỗi khi gửi thông báo đơn hàng:", err);
        }
      }
    );

      // Gửi thông báo cho admin khi tạo đơn hàng thành công
      notificationService.createNotiForAdmin(
        {
          title: "New Order Placed",
          message: `A new order ${orderId} has been placed successfully. Please check the details.`,
          type: "order",
        },
        (err) => {
          if (err) {
            console.error("Lỗi khi gửi thông báo đơn hàng cho admin:", err);
          }
        }
      );

    return order;
  } catch (error) {
    await transaction.rollback();
    throw new Error(`Lỗi khi tạo đơn hàng: ${error.message}`);
  }
};

const findOrderByPayosCode = async (payosCode) => {
  const order = await db.order.findOne({
    where: { payos_order_code: payosCode },
  });

  if (!order) {
    throw new Error(`Không tìm thấy đơn hàng với mã PayOS: ${payosCode}`);
  }

  return order;
};

const updateOrderStatus = async (orderId, updates, transaction = null) => {
  const order = await db.order.findByPk(orderId, { transaction });

  if (!order) {
    throw new Error(`Không tìm thấy đơn hàng: ${orderId}`);
  }

  const prevStatus = order.orderStatus;
  Object.assign(order, updates);
  order.updatedAt = new Date();
  await order.save({ transaction });

  const user = await db.user.findByPk(order.user_id, { transaction });

  if (!user) {
    throw new Error("User không tồn tại.");
  }

  // === Thông báo theo trạng thái ===
  if (updates.orderStatus && updates.orderStatus !== prevStatus) {
    const status = updates.orderStatus;
    let notificationData = null;

    if (status === "processing") {
      notificationData = {
        title: "We’re preparing your order",
        message: `Your order ${order.id} is now being processed. Hang tight!`,
        type: "order",
      };
    } else if (status === "shipping") {
      notificationData = {
        title: "Your order is on the way 🚚",
        message: `Order ${order.id} is now out for delivery. Please be ready to receive it.`,
        type: "order",
      };
    } else if (status === "completed") {
      notificationData = {
        title: "Order delivered successfully 🎉",
        message: `Order ${order.id} has been delivered. Please rate your experience!`,
        type: "order",
      };
    } else if (status === "cancel") {
      notificationData = {
        title: "Order cancelled",
        message: `Your order ${order.id} has been cancelled successfully. You can place a new order anytime.`,
        type: "warning",
      };


        // Gửi thông báo cho admin khi tạo đơn hàng thành công
      notificationService.createNotiForAdmin(
        {
          title: "Order Cancellation Alert",
          message: `A customer has cancelled their order #${order.id}. Please review the cancellation details and take necessary actions.`,
          type: "order",
        },
        (err) => {
          if (err) {
            console.error("Lỗi khi gửi thông báo đơn hàng cho admin:", err);
          }
        }
      );
      
      // Cập nhật lại số lượng bán ra - trừ số lương bán ra trong từng sản phẩm của order

      // Gọi
      // Get
      const items = await db.order_line.findAll({
        where: {
          order_id: orderId,
        },
      });

      // Duyet quan tung item de cap nhat lai so luong san pham
      for (const line of items) {
        const productId = line.product_id;
        const qtyOrdered = line.quantity;

        // Cập nhật giam so luong sản phẩm ban
        await db.product.increment(
          { soldQuantity: -qtyOrdered }, // giảm số lượng
          { where: { id: productId } }
        );
      }
    }

    if (notificationData) {
      await notificationService.createNotification(
        {
          user_id: user.id,
          ...notificationData,
        },
        () => {}
      );
    }
  }

  // === Cộng điểm nếu hoàn tất ===
  if (order.orderStatus === "completed") {
    const currentPoint = user.point || 0;
    const earnedPoint = Math.floor(order.orderTotal / 10000);
    const updatedPoint = currentPoint + earnedPoint;

    await db.user.update(
      { point: updatedPoint },
      { where: { id: order.user_id }, transaction }
    );
  }

  return order;
};

/// ---------- ADMIN - FETCH ALL ORDER -------------- ///
const fetchAllOrders = async (callback) => {
  try {
    const orders = await db.order.findAll({
      include: [
        {
          model: db.shipping_method,
          as: "shippingMethod",
          attributes: ["name_shipping_method", "price"],
        },
        {
          model: db.promotion,
          as: "promotion",
          attributes: ["id", "code", "discount_value"],
        },
        {
          model: db.order_line,
          as: "orderLines",
          attributes: ["product_id", "variant_id", "quantity", "price", "note"],
          include: [
            {
              model: db.product,
              as: "product",
              attributes: ["name_product", "imageUrl"],
            },
            {
              model: db.variant,
              as: "variant",
              attributes: ["id", "variant_name"],
            },
          ],
        },
        {
          model: db.userAddress,
          as: "userAddress",
          include: [
            {
              model: db.address,
              as: "address",
            },
          ],
        },
      ],
    });

    const transformed = orders.map((order) => {
      const o = order.get({ plain: true });

      return {
        id: o.id,
        userId: o.user_id,
        orderStatus: o.orderStatus,
        orderTotal: o.orderTotal,
        shipping_fee: o.shipping_fee,
        address: o.userAddress, // lấy trực tiếp từ include
        payment_method: o.payment_method,
        shippingMethod: o.shippingMethod?.name_shipping_method ?? "",
        promotionCode: o.promotion?.code ?? "",
        promotionDiscount: o.promotion?.discount_value ?? 0,
        orderDate: o.orderDate,
        updatedAt: o.updatedAt,
        paymentStatus: o.paymentStatus,
        paidAt: o.paidAt,
        deliveredAt: o.deliveryCompletedAt,
        notes: o.notes ?? "",
        items: o.orderLines.map((line) => ({
          productName: line.product?.name_product ?? "",
          productId: line.product_id,
          thumbnail: line.product?.imageUrl ?? "",
          variantId: line.variant_id,
          variantName: line.variant?.variant_name ?? "",
          quantity: line.quantity,
          price: line.price,

          note: line.note ?? "",
        })),
      };
    });

    console.log(transformed);

    callback(null, transformed);
  } catch (error) {
    callback(error);
  }
};

module.exports = {
  getAllOrder,
  createOrder,
  getOrderDetail,
  fetchAllOrders,
  createOtherOrder,
  findOrderByPayosCode,
  updateOrderStatus,
};
