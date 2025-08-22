module.exports = (sequelize, DataTypes) => {
    const promotion = sequelize.define('Promotion', {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true,
      },
  
      code: {
        type: DataTypes.STRING,
        allowNull: true,
        unique: true, // mã giảm giá duy nhất
      },
  
      title: {
        type: DataTypes.STRING,
        allowNull: false,
      },
  
      description: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
  
      discount_type: {
        type: DataTypes.ENUM('PERCENTAGE', 'FIXED'),
        allowNull: false,
      },
  
      discount_value: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
  
      max_discount_value: {
        type: DataTypes.FLOAT,
        allowNull: true, // chỉ áp dụng nếu là dạng phần trăm
      },
  
      min_order_value: {
        type: DataTypes.FLOAT,
        allowNull: true, // đơn tối thiểu để áp dụng
      },
  
      applies_to: {
        type: DataTypes.ENUM('ALL', 'PRODUCT', 'CATEGORY'),
        defaultValue: 'ALL',
      },
  
      product_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
  
      category_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
  
      start_date: {
        type: DataTypes.DATE,
        allowNull: false,
      },
  
      end_date: {
        type: DataTypes.DATE,
        allowNull: false,
      },
  
      usage_limit: {
        type: DataTypes.INTEGER,
        allowNull: true, // tổng số lượt dùng
      },
  
      used_count: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
  
      is_active: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
      },
      is_exclusive: {
  type: DataTypes.BOOLEAN,
  defaultValue: false,
  comment: 'Chỉ dành riêng cho khách hàng đặc biệt, không công khai',
},

    }, {
      tableName: 'promotions',
      timestamps: false,
    });
  
    return promotion;
  };
  