module.exports = (sequelize, DataTypes) => {
  const OrderLine = sequelize.define(
    "order_line",
    {
      id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
      },
      order_id: {
        // Foreign Key liên kết với bảng Order
        type: DataTypes.STRING,
        allowNull: false,
      },
      product_id: {
        // Thêm product_id để biết dòng này thuộc sản phẩm nào
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      variant_id: {
        // Biến thể của sản phẩm nếu có (ví dụ: Size, Color,...)
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      quantity: {
        // Số lượng sản phẩm đặt
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      price: {
        // Giá của sản phẩm tại thời điểm đặt hàng
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      note: {
        type: DataTypes.STRING,
        allowNull: true,
      },

      // Check đã review chưa 
      is_review: {
        type: DataTypes.BOOLEAN, 
        defaultValue: false
      }
    },
    {
      tableName: "order_line",
      timestamps: false,
    }
  );

  return OrderLine;
};
