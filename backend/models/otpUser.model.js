const { Sequelize } = require("sequelize");
const sequelize = require("../config/db.config").sequelize; 

module.exports = (sequelize, Sequelize) => {
  const UserOtp = sequelize.define('UserOtp', {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    user_id: {
      type: Sequelize.UUID,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id'
      }
    },
    otp_code: {
      type: Sequelize.STRING,
      allowNull: false
    },
    expires_at: {
      type: Sequelize.DATE,
      allowNull: false
    },
    used: {
      type: Sequelize.BOOLEAN,
      defaultValue: false
    },
    purpose: {
      type: Sequelize.STRING(50),
      allowNull: false,
      comment: 'login, reset_password, verify_email, etc.'
    }
  }, {
    tableName: 'user_otps',
    timestamps: true,
    indexes: [
      {
        name: 'idx_user_otps_user_id',
        fields: ['user_id']
      },
      {
        name: 'idx_user_otps_otp_code',
        fields: ['otp_code']
      }
    ]
  });


  return UserOtp;
}