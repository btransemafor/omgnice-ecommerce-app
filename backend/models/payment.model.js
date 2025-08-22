module.exports = (sequelize, DataTypes) => {
    const Payment = sequelize.define(
      'Payment',
      {
        id: {
          type: DataTypes.INTEGER,
          autoIncrement: true,
          primaryKey: true,
        },
        paymentIntentId: {
          type: DataTypes.STRING,
          allowNull: false,
          unique: true,
        },
        amount: {
          type: DataTypes.FLOAT,
          allowNull: false,
        },
        currency: {
          type: DataTypes.STRING,
          allowNull: false,
        },
        status: {
          type: DataTypes.STRING,
          defaultValue: 'pending',
        },
        userId: {
          type: DataTypes.STRING,
          allowNull: false,
        },
        customerId: {
          type: DataTypes.STRING,
        },
        createdAt: {
          type: DataTypes.DATE,
          defaultValue: DataTypes.NOW,
        },
      },
      {
        tableName: 'Payments',
        timestamps: false,
      }
    );
  
    return Payment;
  };