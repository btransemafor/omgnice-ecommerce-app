// models/AdminNotification.js
module.exports = (sequelize, DataTypes) => {
  const AdminNotification = sequelize.define('AdminNotification', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    message: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    type: {
      type: DataTypes.STRING,
      defaultValue: 'system', // ví dụ: system, order, promo, security, ...
    },
    status: {
      type: DataTypes.BOOLEAN,
      defaultValue: false, // false = chưa đọc, true = đã đọc
    },
    read_at: {
      type: DataTypes.DATE,
      allowNull: true,
    },
  });

  return AdminNotification;
};
