module.exports = (sequelize, DataTypes) => {
    const Address = sequelize.define("address", {
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      ward: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      district: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      province: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      details: {
        type: DataTypes.STRING,
        allowNull: true,
      },
    }, {
      tableName: 'address',
      timestamps: false
    });
  
    return Address;
  };
  