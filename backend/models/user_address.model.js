module.exports = (sequelize, DataTypes) => {
    const UserAddress = sequelize.define("user_address", {
      id: {
        type: DataTypes.UUID, 
        primaryKey: true, 
        defaultValue:DataTypes.UUIDV4, 

      }, 
      user_id: {
        type: DataTypes.UUID,
        //primaryKey: true,
      },
      address_id: {
        type: DataTypes.INTEGER,
        //primaryKey: true,
      },
      is_default: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      fullName: {
        type: DataTypes.STRING, 
        allowNull: true  
      }, 
      phone: {
        type: DataTypes.STRING, 
        allowNull: true , 
      }
    }, 
    {
      tableName: 'user_address',
      timestamps: false,
    });
  
    return UserAddress;
  };
  