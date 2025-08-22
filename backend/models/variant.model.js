// models/variant.model.js
module.exports = (sequelize, DataTypes) => {
    const Variant = sequelize.define('Variant', {
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      variant_name: {
        type: DataTypes.STRING,
        allowNull: false
      }
    }, {
      tableName: 'variant',
      timestamps: false
    });
  
    return Variant;
  };
  