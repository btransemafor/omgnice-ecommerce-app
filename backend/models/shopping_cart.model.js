module.exports = (sequelize, DataTypes) => {
    const ShoppingCart = sequelize.define('ShoppingCart', {
      id: {  
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true
      },
      user_id: {   
        type: DataTypes.UUID,
        allowNull: false,
        unique: true  
      },
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW  // Sequelize tự tạo nếu bạn dùng ShoppingCart.create()
      }
    }, {
      tableName: "shopping_carts",
      timestamps: false  // Nếu bạn không muốn Sequelize tự động thêm `createdAt` và `updatedAt`
    });

    return ShoppingCart;
};



