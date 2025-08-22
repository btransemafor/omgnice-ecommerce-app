const { db } = require("../models/index");
const { generateRandomCode } = require("../utils/code_promotion.utils.js");
const notificationService = require("./notifications.services");

const createPromotionCode = async (data, callback) => {
  try {
    console.log("DATA RECEIVED:", data);

    const is_manual = data.is_manual || false;
    let code;

    if (is_manual && data.code) {
      code = data.code;
    } else {
      code = generateRandomCode();
      console.log("Generated Code:", code);
    }

    const promotion = await db.promotion.create({
      title: data.title,
      description: data.description,
      type: data.type,
      code: code,
      usage_limit: data.usage_limit,
      max_discount_value: data.max_discount_value,
      min_order_value: data.min_order_value,
      discount_type: data.discount_type,
      discount_value: data.discount_value,
      start_date: data.start_date,
      end_date: data.end_date,
      is_active: data.is_active || true,
      quantity: data.quantity,
      min_quantity: data.min_quantity,
      is_exclusive: data.is_exclusive,
    });

    console.log("DEBUG_______________");

    return callback(null, {
      success: true,
      message: "Created Promotion Successfully",
      code: code,
      data: promotion,
    });
  } catch (error) {
    return callback(error);
  }
};

const getPromotion = async (callback) => {
  try {
    const promotions = await db.promotion.findAll({
      where: {
        is_active: true,
        is_exclusive: false,
      },
    });

    callback(null, {
      message: "Get Promotions Successfully",
      data: promotions,
    });
  } catch (error) {
    callback({
      message: "Failed to get promotions",
      error: error.message || error,
    });
  }
};

/// ADMIN

const getPrivatePromotion = async (callback) => {
  try {
    const promotions = await db.promotion.findAll({
      where: {
        is_active: true,
        is_exclusive: true,
      },
    });
    callback(null, {
      message: "Get Promotions Successfully",
      data: promotions,
    });
  } catch (error) {
    callback({
      message: "Failed to get promotions",
      error: error.message || error,
    });
  }
};

const getPromotionByCode = async (code, callback) => {
  try {
    const promotion = await db.promotion.findOne({
      where: { code: code },
    });

    if (!promotion) {
      return callback(null, {
        success: false,
        message: "Mã khuyến mãi không tồn tại",
        data: null,
      });
    }

    if (!promotion.is_active) {
      return callback(null, {
        success: false,
        message: "Mã khuyến mãi không hoạt động",
        data: null,
      });
    }

    if (promotion.end_date && new Date(promotion.end_date) < new Date()) {
      return callback(null, {
        success: false,
        message: "Mã khuyến mãi đã hết hạn",
        data: null,
      });
    }

    // If the promotion is saved and has not reached the usage limit, reject it
    if (promotion.used_count >= promotion.usage_limit) {
      return callback(null, {
        success: false,
        message: "Mã khuyến mãi đã được lưu và hết lượt xử dụng rồi!",
        data: null,
      });
    }

    return callback(null, {
      success: true,
      message: "Lấy mã khuyến mãi thành công",
      data: promotion,
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Không thể lấy mã khuyến mãi",
      error: error.message || error,
    });
  }
};
const addPromotion = async (params, callback) => {
  try {
    const user_id = params.user_id;
    const promotion_id = params.promotion_id;

    // Kiểm tra người dùng tồn tại
    const user = await db.user.findOne({ where: { id: user_id } });
    if (!user) {
      return callback(null, {
        success: false,
        message: "Người dùng không tồn tại",
      });
    }

    // Lấy thông tin khuyến mãi
    const promotion = await db.promotion.findOne({
      where: { id: promotion_id },
    });

    if (!promotion) {
      return callback(null, {
        success: false,
        message: "Khuyến mãi không tồn tại",
      });
    }

    // Kiểm tra giới hạn sử dụng và trạng thái
    if (
      promotion.usage_limit - promotion.used_count < 1 ||
      promotion.is_active === false
    ) {
      return callback(null, {
        success: false,
        message: "Không thể thêm mã vì hết lượt hoặc mã không hoạt động",
      });
    }

    // Kiểm tra xem người dùng đã lưu mã này chưa
    const existing = await db.userPromotion.findOne({
      where: { user_id, promotion_id },
    });
    if (existing) {
      return callback(null, {
        success: false,
        message: "Bạn đã lưu mã này rồi!",
      });
    }

    // Gửi thông báo tùy thuộc vào promotion_id nếu is_exclusive là true
    let notificationMessage = "";
    if (promotion.is_exclusive === true) {
      switch (promotion_id) {
        case 12: // Free Drink Ticket
          notificationMessage = `Great news! You've just been awarded a special exclusive promotion: A Free Drink Ticket! 🎁 Use it to unlock exciting rewards and enjoy a treat on us! 🍹`;
          break;
        case 25: // 50% OFF Voucher
          notificationMessage = `Fantastic news! You've received a special exclusive promotion: A 50% OFF Voucher! 🎉 Redeem it now for amazing savings! 💸`;
          break;
        case 27: // 100K OFF Voucher
          notificationMessage = `Amazing news! You've been awarded a special exclusive promotion: A 100K OFF Voucher! 🎊 Use it to enjoy great discounts! 💰`;
          break;
        case 29: // 250K OFF Voucher
          notificationMessage = `Amazing news! You've been awarded a special exclusive promotion: A 100% Voucher - MAX 250K! 🎊 Use it to enjoy great discounts! 💰`;
          break;
        default :
          notificationMessage = `Great news! You've just been awarded a special exclusive promotion (ID: ${promotion_id}). Use it to unlock exciting rewards!`;
      }

      notificationService.createNotification(
        {
          user_id: user_id,
          title: "Congratulations! 🎉",
          message: notificationMessage,
          type: "promotion",
        },
        (err) => {
          if (err) {
            console.error("Lỗi khi gửi thông báo khuyến mãi:", err);
          }
        }
      );
    }

    // Tăng số lượt sử dụng
    await promotion.increment("used_count");

    // Lưu thông tin vào userPromotion
    await db.userPromotion.create({
      user_id: user_id,
      promotion_id: promotion_id,
    });

    return callback(null, {
      success: true,
      message: "Lưu mã khuyến mãi thành công",
    });
  } catch (error) {
    return callback(error);
  }
};
/// Admin tặng mã cho user

const giftPromotionByAdmin = async (params, callback) => {
  try {
    const { user_id, promotion_id } = params;

    // 2. Kiểm tra user nhận mã có tồn tại
    const user = await db.user.findOne({ where: { id: user_id } });
    if (!user) {
      return callback(null, {
        success: false,
        message: "Người dùng nhận mã không tồn tại",
      });
    }

    // 3. Kiểm tra mã khuyến mãi còn lượt và đang hoạt động
    const promotion = await db.promotion.findOne({
      where: { id: promotion_id },
    });
    if (
      !promotion ||
      promotion.is_active === false ||
      promotion.usage_limit - promotion.used_count < 1
    ) {
      return callback(null, {
        success: false,
        message: "Mã khuyến mãi không hợp lệ hoặc đã hết lượt sử dụng",
      });
    }

    // 4. Kiểm tra user đã có mã chưa
    const existing = await db.userPromotion.findOne({
      where: { user_id, promotion_id },
    });
    if (existing) {
      return callback(null, {
        success: false,
        message: "Người dùng đã được tặng mã này rồi",
      });
    }

    // 5. Tăng số lượt đã dùng của mã
    await promotion.increment("used_count");

    // 6. Tạo liên kết user - promotion (tặng mã)
    await db.userPromotion.create({
      user_id,
      promotion_id,
    });

    notificationService.createNotification(
      {
        user_id: user.id,
        title: "You've Got a New Promotion!",
        message: `Hi ${user.name}, you’ve received a special promotion from OMGNICE}. Check it out now and don’t miss the deal!`,
        type: "promotion",
      },
      (err) => {
        if (err) {
          console.error("Lỗi khi gửi thông báo khuyến mãi:", err);
        }
      }
    );

    return callback(null, {
      success: true,
      message: "Tặng mã khuyến mãi thành công cho người dùng",
    });
  } catch (error) {
    return callback(error);
  }
};

const getUserPromotions = async (user_id, callback) => {
  try {
    const user = await db.user.findByPk(user_id, {
      include: [
        {
          model: db.promotion,
          as: "usedPromotions",
          through: {
            attributes: [],
          },
        },
      ],
    });

    console.log(user);

    if (!user) {
      return callback(null, {
        success: false,
        data: [],
        message: "Người dùng không tồn tại",
      });
    }

    if (!user.usedPromotions || user.usedPromotions.length === 0) {
      return callback(null, {
        success: true,
        data: [],
        message: "Không tìm thấy mã khuyến mãi nào cho người dùng này",
      });
    }

    return callback(null, {
      success: true,
      data: user.usedPromotions,
      message: "Lấy danh sách mã khuyến mãi thành công",
    });
  } catch (error) {
    console.error(error);
    return callback(error, {
      success: false,
      message: "Lỗi khi lấy danh sách mã khuyến mãi",
    });
  }
};

const deleteUserPromotion = async (params, callback) => {
  try {
    const { user_id, promotion_id } = params;

    const user = await db.user.findOne({ where: { id: user_id } });
    if (!user) {
      return callback(null, {
        success: false,
        message: "Người dùng không tồn tại",
      });
    }

    const promotion = await db.promotion.findOne({
      where: { id: promotion_id },
    });
    if (!promotion) {
      return callback(null, {
        success: false,
        message: "Mã khuyến mãi không tồn tại",
      });
    }

    const userPromotion = await db.userPromotion.findOne({
      where: { user_id, promotion_id },
    });
    if (!userPromotion) {
      return callback(null, {
        success: false,
        message: "Người dùng chưa lưu mã khuyến mãi này",
      });
    }

    await db.promotion.decrement("used_count", {
      where: { id: promotion_id },
    });

    await db.userPromotion.destroy({
      where: { user_id, promotion_id },
    });

    return callback(null, {
      success: true,
      message: "Xóa mã khuyến mãi khỏi người dùng thành công",
    });
  } catch (error) {
    console.error("Lỗi khi xóa mã khuyến mãi:", error);
    return callback({
      success: false,
      message: "Không thể xóa mã khuyến mãi",
      error: error.message || error,
    });
  }
};

module.exports = {
  createPromotionCode,
  getPromotion,
  getPromotionByCode,
  addPromotion,
  getUserPromotions,
  deleteUserPromotion,
  getPrivatePromotion,
  giftPromotionByAdmin,
};
