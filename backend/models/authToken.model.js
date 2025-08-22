// models/AuthToken.js
module.exports = (sequelize, DataTypes) => {
    const AuthToken = sequelize.define('auth_token', {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      user_id: {
        type: DataTypes.UUID,
        allowNull: false,
      },
      token: {
        type: DataTypes.TEXT,
        allowNull: false,
      },
      expires_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      is_active: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
      },
    }, {
      tableName: 'auth_token',
      timestamps: false, 
    });
  
    return AuthToken;
  };
  