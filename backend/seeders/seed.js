'use strict';

const { v4: uuidv4 } = require('uuid');

module.exports = {
  async up (queryInterface, Sequelize) {
    const users = await queryInterface.sequelize.query(
      `SELECT id FROM "users";`
    );
    const userRows = users[0];

    if (userRows.length === 0) return;

    const notifications = userRows.flatMap((user) => [
      {
        id: uuidv4(),
        user_id: user.id,
        title: 'Welcome to OMGNice!',
        message: 'Thanks for signing up. Happy to have you! ❤️',
        type: 'system',
        status: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        id: uuidv4(),
        user_id: user.id,
        title: 'Your order has been delivered',
        message: 'Please rate your experience. ⭐️',
        type: 'order',
        status: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ]);

    await queryInterface.bulkInsert('notifications', notifications);
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('notifications', null, {});
  }
};
