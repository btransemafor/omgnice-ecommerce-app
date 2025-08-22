'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert('promotions', [
    {
        code: "DRINK100OFF",
        title: "100% Off Your Drink!",
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
        is_active: true,
      },

       {
        code: "DRINK100OFF",
        title: "100% Off Your Drink!",
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
        is_active: true,
      },
     
     
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('promotions', null, {});
  }
};
