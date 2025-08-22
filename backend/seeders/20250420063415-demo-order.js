'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    /**
     * Add seed commands here.
     *
     * Example:
     * await queryInterface.bulkInsert('People', [{
     *   name: 'John Doe',
     *   isBetaMember: false
     * }], {});
    */

    await queryInterface.bulkInsert('orders', [
      {
        id: 'ORD00001',
        user_id: 'f615dd8b-a9fa-431d-9637-eb1b5cb67d6d',
        orderDate: new Date(),
        address_id: 1,
        shipping_method_id: 'a4c13e08-6392-4f38-8a1d-8bbfd50d2a50',
        payment_method: 'COD',
        orderTotal: 399.99,
        orderStatus: 'processing',
        promotion_id: null,
        deliveryCompletedAt: null,
        updatedAt: new Date(),
        notes: 'Giao sáng sớm',
        shipping_fee: 20,
        discount_amount: 15,
      },
      {
        id: 'ORD00002',
        user_id: 'f615dd8b-a9fa-431d-9637-eb1b5cb67d6d',
        orderDate: new Date(),
        address_id: 1,
        shipping_method_id: 'a4c13e08-6392-4f38-8a1d-8bbfd50d2a50',
        payment_method: 'VNPAY',
        orderTotal: 520.5,
        orderStatus: 'shipped',
        promotion_id: null,
        deliveryCompletedAt: new Date(),
        updatedAt: new Date(),
        notes: 'Không gọi điện',
        shipping_fee: 25,
        discount_amount: 30,
      },
      {
        id: 'ORD00003',
        user_id: 'f615dd8b-a9fa-431d-9637-eb1b5cb67d6d',
        orderDate: new Date(),
        address_id:   1,
        shipping_method_id: 'a4c13e08-6392-4f38-8a1d-8bbfd50d2a50',
        payment_method: 'CreditCard',
        orderTotal: 150.75,
        orderStatus: 'delivered',
        promotion_id: null,
        deliveryCompletedAt: new Date(),
        updatedAt: new Date(),
        notes: null,
        shipping_fee: 10,
        discount_amount: 5,
      },
    ]);
  },

  async down (queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  }
};
