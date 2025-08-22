// models/product.model.js
module.exports = (sequelize, DataTypes) => {
  const Product = sequelize.define('Product', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name_product: DataTypes.STRING,
    description: DataTypes.TEXT,
    soldQuantity: DataTypes.INTEGER,
    stockQuantity: DataTypes.INTEGER,
    imageUrl: DataTypes.STRING,
    discount_percent: DataTypes.DOUBLE,

    // Thêm trường mới tại đây
    isHidden: {
      type: DataTypes.BOOLEAN,
      defaultValue: false, // false = hiển thị, true = ẩn
    },

    category_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'category',
        key: 'id'
      }
    },
    is_premium: {
      type: DataTypes.BOOLEAN, 
    }
    ,//  Tự khai báo createdAt với default là null
    createdAt: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
    },

    updatedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
    }
  }, {
    tableName: 'product',
    timestamps: false
  });

  return Product;
};
