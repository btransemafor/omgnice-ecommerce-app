module.exports = (sequelize, DataTypes) => {
  const Notification = sequelize.define('notification', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    user_id: {
      type: DataTypes.UUID,
      allowNull: true, // Nếu null thì là thông báo hệ thống (broadcast)
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
      defaultValue: 'system', // system, order, promo, security, etc.
    },
    status: {
      type: DataTypes.BOOLEAN,
      defaultValue: false, // false = chưa đọc
    },

    read_at: {
      type: DataTypes.DATE,
      allowNull: true,
    }
  });

  // Tạo quan hệ với User (nếu cần)
/*   Notification.associate = (models) => {
    Notification.belongsTo(models.user, {
      foreignKey: 'user_id',
      as: 'user',
      onDelete: 'CASCADE',
    });
  };
 */
  return Notification;
};
