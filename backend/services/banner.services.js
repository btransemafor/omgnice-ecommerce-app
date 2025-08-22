const { db } = require("../models/index");
const { Op } = require("sequelize");

const getbanners = async (callback) => {
  try {
    const banners = await db.banner.findAll({
      where: {
        start_time: {
          [Op.lte]: new Date(), // Op.lte : nhỏ hơn bằng 
        },
        end_time: {
          [Op.or]: [{ [Op.gte]: new Date() }, { [Op.is]: null }],
        },
      },
      order: [["created_at", "DESC"]],
    });

    return callback(null, {
      success: true,
      message: "Get Banners Successfully!",
      data: banners,
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Lỗi máy chủ!",
      error: error.message,
    });
  }
};

// CREATE BANNER
const createBanner = async (banner, callback) => {
  try {
    console.log(banner);
    if (!banner || typeof banner !== "object") {
      return callback(new Error("Invalid banner object"));
    }
    const newBanner = await db.banner.create(banner); // Sequelize create
    callback(null, newBanner);
  } catch (err) {
    callback(err);
  }
};

/// DELETE BANNER
const deleteBanner = async (banner_id, callback) => {
  try {
    console.log(`Xoa banner ${banner_id}`);
    await db.banner.destroy({ where: { id: banner_id } });
    return callback(null, {
      message: "Deleted Banner Successfully!",
    });
  } catch (err) {
    callback(err);
  }
};

module.exports = {
  getbanners,
  createBanner,
  deleteBanner
};
