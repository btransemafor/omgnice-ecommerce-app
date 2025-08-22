// models/variant_product.model.js
module.exports = (sequelize, DataTypes) => {
    const VariantProduct = sequelize.define('VariantProduct', {
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      product_id: {
        type: DataTypes.INTEGER,
        references: {
          model: 'product',
          key: 'id',
        },
        allowNull: false,
      },
      variant_id: { // 👈 Thêm trường này để biết là size S/M/L
        type: DataTypes.INTEGER,
        references: {
          model: 'variant', // bảng chứa size S, M, L
          key: 'id',
        },
        allowNull: false,
      },
      price: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      discount_price: {
        type: DataTypes.FLOAT,
        allowNull: true,
      },
    }, {
      tableName: 'variant_product',
      timestamps: false,
    });
  
    return VariantProduct;
  };
  