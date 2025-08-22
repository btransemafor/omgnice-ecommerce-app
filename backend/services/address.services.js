const { where } = require("sequelize");
const { db, sequelize } = require("../models/index.js");
const { Op } = require("sequelize");

// Create Address
// Create Address
const createAddress = async (new_address, callback) => {
  try {
    const {
      user_id,
      ward,
      district,
      province,
      details,
      is_default,
      fullName,
      phone,
    } = new_address;

    if (!ward || !district || !province) {
      return callback({
        success: false,
        message: "Thiếu dữ liệu cần thiết!",
      });
    }

    const transaction = await sequelize.transaction();

    try {
      // 1. Tạo địa chỉ
      const address = await db.address.create(
        {
          ward,
          district,
          province,
          details,
        },
        { transaction }
      );

      // 2. Nếu là địa chỉ mặc định thì cập nhật các địa chỉ khác của user thành false
      if (is_default === true) {
        await db.userAddress.update(
          { is_default: false },
          {
            where: { user_id },
            transaction,
          }
        );
      }

      // 3. Tạo userAddress
      const userAddress = await db.userAddress.create(
        {
          user_id,
          address_id: address.id,
          is_default: is_default === undefined ? false : is_default,
          fullName,
          phone,
        },
        { transaction }
      );

      // 4. Commit
      await transaction.commit();
      // Kiem tra xem so dien thoai da co trong bang user chua ?

      const user = await db.user.findOne({ where: { id: user_id } });

      if (user && !user.phone) {
        await db.user.update({ phone: phone }, { where: { id: user_id } });
      }

      return callback(null, {
        success: true,
        message: "Created Address Successfully!",
        data: address.id,
      });
    } catch (error) {
      await transaction.rollback();
      return callback({
        success: false,
        message: "Lỗi khi lưu dữ liệu!",
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

const updateAddress = async (new_address, callback) => {
  const {
    id,
    fullName,
    phone,
    is_default,
    ward,
    district,
    province,
    details,
    user_id,
  } = new_address;

  try {
    if (!id || !user_id) {
      return callback(null, {
        success: false,
        message: "Thiếu ID hoặc User ID!",
      });
    }

    // 1. Tìm bản ghi user_address
    const user_address = await db.userAddress.findOne({
      where: { id, user_id },
    });
    if (!user_address) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy địa chỉ của người dùng!",
      });
    }

    // 2. Nếu đang chọn là mặc định → set tất cả các bản ghi khác về false

    if (is_default === true) {
      const updated = await db.userAddress.update(
        { is_default: false },
        {
          where: {
            user_id: user_id,
            id: { [Op.ne]: id }, // khác id hiện tại
          },
        }
      );
      console.log("Số bản ghi is_default=false đã cập nhật:", updated);
    }

    // 3. Cập nhật bản ghi hiện tại
    const userAddressUpdateData = {};
    if (typeof is_default !== "undefined")
      userAddressUpdateData.is_default = is_default;
    if (fullName) userAddressUpdateData.fullName = fullName;
    if (phone) userAddressUpdateData.phone = phone;

    if (Object.keys(userAddressUpdateData).length > 0) {
      await user_address.update(userAddressUpdateData);
    }

    // 4. Tìm và cập nhật địa chỉ thật (bảng address)
    const address = await db.address.findOne({
      where: { id: user_address.address_id },
    });
    if (!address) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy địa chỉ trong bảng address!",
      });
    }

    const addressUpdateData = {};
    if (ward) addressUpdateData.ward = ward;
    if (district) addressUpdateData.district = district;
    if (province) addressUpdateData.province = province;
    if (details) addressUpdateData.details = details;

    if (Object.keys(addressUpdateData).length > 0) {
      await address.update(addressUpdateData);
    }

    return callback(null, {
      success: true,
      message: "Cập nhật địa chỉ thành công!",
      data: {
        user_address_id: user_address.id,
        address_id: address.id,
      },
    });
  } catch (error) {
    return callback({
      success: false,
      message: "Đã xảy ra lỗi khi cập nhật địa chỉ!",
      error: error.message,
    });
  }
};

/// ---------------------- Fetch List Address user ---------------- //
const fetchListAddress = async (user_id, callback) => {
  try {
    const addressList = await db.userAddress.findAll({
      where: { user_id },
      include: [
        {
          model: db.address,
          as: "address",
        },
      ],
      // order: [['createdAt', 'DESC']],
    });

    return callback(null, {
      success: true,
      message: "Fetched address list successfully!",
      data: addressList,
    });
  } catch (error) {
    console.error("Error fetching addresses:", error);
    return callback({
      success: false,
      message: "Failed to fetch address list!",
      error: error.message,
    });
  }
};

// Delete Address
const deleteAddress = async (params, callback) => {
  try {
    const { user_id, id } = params;

    console.log(`DEBUG - delete address id: ${id}, user: ${user_id}`);

    // 1. Tìm bản ghi user_address và đảm bảo đúng user
    const user_address = await db.userAddress.findOne({
      where: {
        id: id,
        user_id: user_id, // tránh người khác xoá giùm
      },
    });

    if (!user_address) {
      return callback({
        success: false,
        message: "Address not found or does not belong to the user.",
        code: 404,
      });
    }

    const address_id = user_address.address_id || user_address.id;

    // 2. Xoá user_address
    await user_address.destroy();

    // 3. Tìm và xoá address nếu có
    const address = await db.address.findOne({ where: { id: address_id } });
    if (address) {
      await address.destroy();
    }

    return callback(null, {
      message: "Deleted Address Successfully!",
    });
  } catch (error) {
    return callback(error);
  }
};

module.exports = {
  createAddress,
  updateAddress,
  fetchListAddress,
  deleteAddress,
};

// ward: {
//     type: DataTypes.STRING,
//     allowNull: false,
//   },
//   district: {
//     type: DataTypes.STRING,
//     allowNull: false,
//   },
//   province: {
//     type: DataTypes.STRING,
//     allowNull: false,
//   },
//   details: {
//     type: DataTypes.STRING,
//     allowNull: true,
//   },
