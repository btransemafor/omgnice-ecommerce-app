const { Sequelize } = require("sequelize");
const sequelize = require("../config/db.config").sequelize; 

module.exports = (sequelize, DataTypes) => {
  const Role = sequelize.define('Role', {
    role_id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,  // Tự động tăng giá trị
      allowNull: false,     // Không được để null
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: false
    }
  }, {
    tableName: 'roles', // Tên bảng trong DB
    timestamps: true,    // Sử dụng createdAt & updatedAt
  });

  return Role;
};
