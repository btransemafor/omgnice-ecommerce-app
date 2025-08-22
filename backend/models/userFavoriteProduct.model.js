module.exports = (sequelize, DataTypes) => {
    const UserFavoriteProduct = sequelize.define('UserFavoriteProduct', {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      user_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      product_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    }, {
      tableName: 'user_favorite_products',
      timestamps: false,
    });
  
    return UserFavoriteProduct;
  };
  