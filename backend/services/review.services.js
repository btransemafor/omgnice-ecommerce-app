const { db } = require("../models/index");

const createReview = async (
  { user_id, order_line_id, rating_star, comment },
  callback
) => {
  try {
    console.log("CHECKING VALIDITY...");
    // Kiem tra xem thử người dùng đã mua và đơn hàng này ở trang thái completed chưa ?
    const isValidUserOfOrderLine = await db.order.findOne({
      where: {
        user_id,
        orderStatus: "completed",
      },
      include: [
        {
          model: db.order_line,
          as: "orderLines",
          where: {
            id: order_line_id,
          },
        },
      ],
    });

    console.log(isValidUserOfOrderLine);

    if (!isValidUserOfOrderLine) {
      // status code 403
      return callback(null, {
        success: false,
        message: "You are not allowed to review this product.",
      });
    }

    const existedReview = await db.review.findOne({
      where: { order_line_id },
    });
    if (existedReview) {
      return callback(null, {
        success: false,
        message: "You already reviewed this product.",
      });
    }
    /// Create a record review
    // order_line_id, comment, rating_star, review_date : Mới nhất
    const userReview = await db.review.create({
      order_line_id,
      user_id,
      rating_star,
      comment: comment || "",
      review_date: new Date(),
    });

    // Cập nhật trạng thái đã review trong order_line_id
    try {
      await db.order_line.update(
        { is_review: true },
        { where: { id: order_line_id } }
      );

      console.log("Update Status Review Successfully");
    } catch (error) {
      console.log("Khong the cap nhat trang thai review vao order_line_id");
    }

    return callback(null, {
      success: true,
      message: "Tạo review đánh giá thành công!",
      data: userReview,
    });
  } catch (error) {
    return callback(error);
  }
};

// ----------- Get Danh sach review của từng sản phẩm ------------------
//  product/:id/reviews

const getReviews = async (product_id, callback) => {
  try {
    const reviews = await db.review.findAll({
      include: [
        {
          model: db.order_line,
          as: "orderLine",
          attributes: ["product_id", "variant_id"],
          where: { product_id },
        },
        {
          model: db.user,
          as: "user",
          attributes: ["name", "avatar"],
        },
      ],
      order: [["review_date", "DESC"]],
    });

    const flatReviews = reviews.map((review) => ({
      id: review.id,
      user_id: review.user_id,
      order_line_id: review.order_line_id,
      rating_star: review.rating_star,
      comment: review.comment,
      review_date: review.review_date,
      product_id: review.orderLine?.product_id || null,
      variant_id: review.orderLine?.variant_id || null,
      user: review.user || null,
    }));

    return callback(null, {
      success: true,
      message: "Get reviews successfully",
      data: flatReviews || [],
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Internal Server Error",
      error: error.message,
    });
  }
};

module.exports = {
  createReview,
  getReviews,
};
