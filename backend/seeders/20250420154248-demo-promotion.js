"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    /**
     * Add seed commands here.
     *
     * Example:
     * await queryInterface.bulkInsert('People', [{
     *   name: 'John Doe',
     *   isBetaMember: false
     * }], {});
     */
    return queryInterface.bulkInsert("promotions", [
      /*  {
          code: 'DISCOUNT10',
          title: '10% Off on All Orders',
          description: 'Applicable to all products',
          discount_type: 'PERCENTAGE',
          discount_value: 10,
          max_discount_value: 50000,
          min_order_value: 100000,
          applies_to: 'ALL',
          product_id: null,
          category_id: null,
          start_date: new Date('2025-04-01'),
          end_date: new Date('2025-05-01'),
          usage_limit: 100,
          used_count: 0,
          is_active: true,
        },
        {
          code: 'FIXED50K',
          title: '50,000₫ Off on Orders',
          description: 'Only applicable to the product: Watermelon Juice',
          discount_type: 'FIXED',
          discount_value: 50000,
          max_discount_value: null,
          min_order_value: 200000,
          applies_to: 'PRODUCT',
          product_id: 1,
          category_id: null,
          start_date: new Date('2025-04-10'),
          end_date: new Date('2025-05-10'),
          usage_limit: 50,
          used_count: 10,
          is_active: true,
        },
        {
          code: 'CATEGORY20',
          title: '20% Off for Coffee Category',
          description: 'Only applicable to category: Coffees',
          discount_type: 'PERCENTAGE',
          discount_value: 20,
          max_discount_value: 100000,
          min_order_value: 300000,
          applies_to: 'CATEGORY',
          product_id: null,
          category_id: 3,
          start_date: new Date('2025-04-05'),
          end_date: new Date('2025-06-01'),
          usage_limit: 200,
          used_count: 25,
          is_active: true,
        } */

      {
        code: "OMGNICEMEME50%",
        title: "50% Off Your Drink!",
        description:
          "Enjoy a free drink of your choice. Valid for all items, one-time use only.",
        discount_type: "PERCENTAGE",
        discount_value: 100,
        max_discount_value: 200000, // Giới hạn tối đa giá trị giảm (1 ly nước)
        min_order_value: 0,
        applies_to: "ALL",
        product_id: null,
        category_id: null,
        start_date: "2025-05-23T00:00:00Z",
        end_date: "2025-06-30T23:59:59Z",
        usage_limit: 5000,
        used_count: 0,
        is_active: false,
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  },
};
