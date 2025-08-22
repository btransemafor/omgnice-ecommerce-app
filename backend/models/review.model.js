module.exports = (sequelize, DataTypes) => {
  const Review = sequelize.define(
    "Review",
    {
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      user_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      order_line_id: {
        // New field for foreign key
        type: DataTypes.UUID,
        allowNull: false,
      },
      rating_star: {
        type: DataTypes.INTEGER,
        validate: {
          min: 1,
          max: 5,
        },
      },
      comment: {
        // New field for the comment
        type: DataTypes.STRING,
        allowNull: true,
      },
      review_date: {
        // New field for review date
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      tableName: "review",
      timestamps: false,
    }
  );

  // Uncomment and update associations as needed
  /*
  Review.associate = (models) => {
    Review.belongsTo(models.User, { foreignKey: 'user_id' });
    Review.belongsTo(models.ProductVariant, { foreignKey: 'variant_id' });
    Review.belongsTo(models.OrderLine, { foreignKey: 'order_line_id' }); // New association for order_line_id
  };
  */

  return Review;
};
