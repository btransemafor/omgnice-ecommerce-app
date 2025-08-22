module.exports = (sequelize, DataTypes) => {
  const Banner = sequelize.define(
    "Banner",
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },

      title: {
        type: DataTypes.STRING,
        allowNull: false,
      },

      imageUrl: {
        type: DataTypes.TEXT,
        allowNull: false,
        field: "image_url",
      },

      actionType: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "action_type",
        validate: {
          isIn: [["LUCKY_WHEEL", "PRODUCT", "CATEGORY"]],
        },
      },

      actionValue: {
        type: DataTypes.STRING,
        allowNull: true,
        field: "action_value",
      },

      productId: {
        type: DataTypes.INTEGER,
        allowNull: true,
        field: "product_id",
        references: {
          model: "products", // tên bảng trong DB
          key: "id",
        },
      },

      categoryId: {
        type: DataTypes.INTEGER,
        allowNull: true,
        field: "category_id",
        references: {
          model: "categories",
          key: "id",
        },
      },
      isLuckyWheelBanner: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
        field: "is_lucky_wheel_banner",
      },

      startTime: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
        field: "start_time",
      },

      endTime: {
        type: DataTypes.DATE,
        allowNull: true,
        field: "end_time",
      },
    },
    {
      tableName: "banners",
      timestamps: true,
      createdAt: "created_at",
      updatedAt: false,
    }
  );

  return Banner;
};
