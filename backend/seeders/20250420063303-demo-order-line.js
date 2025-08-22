'use strict';
const { v4: uuidv4 } = require('uuid');
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



    await queryInterface.bulkInsert('order_line', [

      {
        id: uuidv4(),  // hoặc dùng uuid package để tạo sẵn
        order_id: 'ORD00001',    // giả sử đã có order này trong bảng orders
        product_id: 1,
        variant_id: 3,
        quantity: 2,
        price: 199.99,
        note: 'Giao nhanh, đóng gói kỹ',
      },
      {
        id: uuidv4(),
        order_id: 'ORD00001',
        product_id: 2,
        variant_id: 2, 
        quantity: 1,
        price: 89.5,
        note: null,
      },

      {
        id:  uuidv4(),
        order_id: 'ORD00001',
        product_id: 2,
        variant_id: 1,
        quantity: 1,
        price: 89.5,
        note: null,
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
