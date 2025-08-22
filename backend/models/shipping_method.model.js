module.exports = (sequelize, DataType) => {
  //

  const ShippingMethod = sequelize.define(
    "ShippingMethod",
    {
      id: {
        type: DataType.UUID,
        primaryKey: true,
        allowNull: false,
      },
      name_shipping_method: DataType.STRING,
      price: {
        type: DataType.DOUBLE,
        defaultValue: 0,
      },
      description: {
        type: DataType.STRING,
      },

      discount_price: {
        type: DataType.DOUBLE,
        defaultValue: 0,
      },
    },
    {
      tableName: "Shipping_methods",
      timestamps: false,
    }
  );
  return ShippingMethod;
};
