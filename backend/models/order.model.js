/* const { DataTypes } = require("sequelize");
const { generateOrderId } = require("../utils/order.utils");
const {db} = require('./index'); 
module.exports = (sequelize, DataTypes) => {
  const Order = sequelize.define(
    "Order",
    {
      id: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false,
        unique: true,
      },
      user_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      orderDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      address_id: {
        type: DataTypes.UUID,  
        allowNull: false,
      },
      
      shipping_method_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      payment_method: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      orderTotal: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      shipping_fee: {
        type: DataTypes.FLOAT,
        allowNull: false,
        defaultValue: 0,
      },
      promotion_id: {
        type: DataTypes.INTEGER,
        allowNull: true, 
      },
      discount_amount: {
        type: DataTypes.FLOAT,
        allowNull: false,
        defaultValue: 0,
      },
      delivery_time_slot: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      
      orderStatus: {
        type: DataTypes.STRING,
        defaultValue: "processing",
      },
      delivery_time_slot: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      
      deliveryCompletedAt: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      updatedAt: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      notes: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      paymentStatus: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false, // False nếu chưa thanh toán, true nếu đã thanh toán
      }, 
    },


    
    {
      tableName: "orders",
      timestamps: false,
    }
  );
  
  //  Hook `beforeValidate` để đảm bảo tạo `id` trước khi tạo đơn hàng
  //  Dùng beforeCreate vẫn sai trong tình huống này vì sequelize kiểm tra tính hợp lệ trước
  //

  Order.beforeValidate(async (order) => {
    if (!order.id) {
      order.id = await generateOrderId(Order);
    }
  });

  return Order;
};
 */

const { generateOrderId } = require("../utils/order.utils");

module.exports = (sequelize, DataTypes) => {
  const Order = sequelize.define(
    "Order",
    {
      id: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false,
        unique: true,
      },
      user_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      orderDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      address_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      shipping_method_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      payment_method: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      orderTotal: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      shipping_fee: {
        type: DataTypes.FLOAT,
        allowNull: false,
        defaultValue: 0,
      },
      promotion_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      discount_amount: {
        type: DataTypes.FLOAT,
        allowNull: false,
        defaultValue: 0,
      },
      delivery_time_slot: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      orderStatus: {
        type: DataTypes.STRING,
        defaultValue: "processing",
      },
      deliveryCompletedAt: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      updatedAt: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      notes: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      paymentStatus: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },
      paymentId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      payos_order_code: {
        type: DataTypes.INTEGER,
        allowNull: true,
        unique: true,
      },
      paidAt: {
        type: DataTypes.DATE,
        allowNull: true, 
      },
    },
    {
      tableName: "orders",
      timestamps: false,
    }
  );

  Order.beforeValidate(async (order) => {
    if (!order.id) {
      order.id = await generateOrderId(Order);
    }
  });

  return Order;
};
