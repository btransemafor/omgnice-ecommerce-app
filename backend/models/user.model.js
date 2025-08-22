module.exports = (sequelize, Sequelize) => {
  const User = sequelize.define(
    "User",
    {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true,
      },

      name: Sequelize.STRING,

      email: {
        type: Sequelize.STRING,
        unique: true,
        allowNull: false,
      },
       last_spin_date: {
        type: Sequelize.DATEONLY,
        allowNull: true,
      },
      spins_today: {
        type: Sequelize.INTEGER,
        allowNull: true,
        defaultValue: 0,
      }, 

      phone: Sequelize.STRING,

      // Với login truyền thống
      password: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      // Thêm điểm thưởng
      point: {
        type: Sequelize.INTEGER,
        allowNull: true,
      },

      // Liên kết role
      role_id: {
        type: Sequelize.INTEGER,
        references: {
          model: "roles",
          key: "role_id",
        },
      },

      active: {
        type: Sequelize.BOOLEAN,
        defaultValue: false,
      },

      // Thêm các trường cho đăng nhập xã hội
      provider: {
        type: Sequelize.ENUM("local", "google", "facebook"),
        allowNull: false,
        defaultValue: "local",
      },

      providerId: {
        type: Sequelize.STRING,
        allowNull: true,
      },

      avatar: {
        type: Sequelize.STRING,
        allowNull: true,
      },
      // is_block 
      is_active: {
        type: Sequelize.BOOLEAN, 
        allowNull: false, 
        defaultValue: true
        
      }
    },
    {
      tableName: "users",
      timestamps: true,
    }
  );

  return User;
};
