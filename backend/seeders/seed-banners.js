'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkInsert('banners', [
      {
        title: 'Khuyến mãi đặc biệt',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1744299688/OMGNICE_hsu4zs.png',
        action_type: '2', // ID_category
        action_value: null,
        start_time: new Date('2025-04-01T00:00:00Z'),
        end_time: new Date('2025-04-30T23:59:59Z'),
        created_at: new Date()
      },
      {
        title: 'Ưu đãi món đặc biệt',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1744298721/0338498306_xp0g6j.png',
        action_type: 'PRODUCT',
        action_value: '5',  // ID sản phẩm
        start_time: new Date(),
        end_time: null,
        created_at: new Date()
      },
      {
        title: 'Coffee Discount',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1744298148/Brown_Gradient_Elegant_Coffee_Shop_Banner_u9o9f2.png',
        action_type: 'CATEGORY',
        action_value: '3',  // slug hoặc ID danh mục
        start_time: new Date('2025-04-05T00:00:00Z'),
        end_time: new Date('2025-05-01T00:00:00Z'),
        created_at: new Date()
      }
    ], {});
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('banners', null, {});
  }
};
