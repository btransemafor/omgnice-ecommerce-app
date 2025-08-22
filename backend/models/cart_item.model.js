module.exports = (sequelize, DataTypes) => {
  const CartItem = sequelize.define('CartItem', {
    id: {  // Khóa chính riêng
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    cart_id: {   // Liên kết tới Cart
      type: DataTypes.UUID,
      allowNull: false, 
    },
    variant_id: {  // Liên kết tới Variant
      type: DataTypes.INTEGER,
      allowNull: false, 
    },
    product_id: {  // Liên kết tới Product
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    quantity: {
      type: DataTypes.INTEGER,
      defaultValue: 1,
    },
    note: DataTypes.TEXT,
  }, {
    tableName: "cart_items", 
    timestamps: false,
    indexes: [
      {
        unique: true,
        fields: ['cart_id', 'variant_id', 'product_id']  // Đảm bảo 1 sản phẩm cụ thể (product_id + variant_id) chỉ có 1 trong 1 cart
      }
    ]
  });

  return CartItem; 
}
