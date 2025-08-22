const { DataTypes } = require("sequelize");
const sequelize = require("../config/db.config").sequelize;

const PasswordResetToken = sequelize.define(
  "PasswordResetToken",
  {
    email: {
      type: DataTypes.STRING,
      primaryKey: true,
    },
    token: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    created_at: {
      type: DataTypes.DATE,
      allowNull: true,
    },
  },
  {
    timestamps: false,
    tableName: "password_reset_tokens",
  }
);

module.exports = PasswordResetToken;
