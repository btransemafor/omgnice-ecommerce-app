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

    await queryInterface.bulkInsert('banners', [
      {
        title: 'SPIN LUCKY',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1748063609/lucky_qbeesi.png',
        action_type: 'LUCKY_WHEEL',
        action_value: null,
        product_id: null,
        category_id: null,
        start_time: new Date('2025-05-24T00:00:00Z'),
        end_time: new Date('2025-06-30T23:59:59Z'),
        created_at: new Date(), 
        is_lucky_wheel_banner: true 
      },

      /*
      {
        title: 'Ưu đãi món đặc biệt',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1744298721/0338498306_xp0g6j.png',
        action_type: 'PRODUCT',
        action_value: '5',
        product_id: null, // ID thật của sản phẩm (phải tồn tại trong DB)
        category_id: null,
        start_time: new Date(),
        end_time: null,
        created_at: new Date()
      },
      {
        title: 'Coffee Discount',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1744298148/Brown_Gradient_Elegant_Coffee_Shop_Banner_u9o9f2.png',
        action_type: 'CATEGORY',
        action_value: '3',
        product_id: null,
        category_id: null, // ID thật của danh mục (phải tồn tại trong DB)
        start_time: new Date('2025-04-05T00:00:00Z'),
        end_time: new Date('2025-05-01T00:00:00Z'),
        created_at: new Date()
      }, 


       {
        title: 'Fresh Summer Banner',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1747150557/Bittersweet_and_Sky_Blue_Watercolor_Summer_Drinks_Banner_Promotion_ugkpy4.png',
        action_type: 'CATEGORY',
        action_value: '2',
        product_id: null,
        category_id: 2, // ID thật của danh mục (phải tồn tại trong DB)
        start_time: new Date('2025-04-05T00:00:00Z'),
        end_time: new Date('2025-06-30T00:00:00Z'),
        created_at: new Date()
      }, 
 */
      
      /*  {
        title: 'Water Melon Discount',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1747152642/0338498306_3_bafw9z.png',
        action_type: 'PRODUCT',
        action_value: '7',
        product_id: null,
        category_id: null, // ID thật của danh mục (phải tồn tại trong DB)
        start_time: new Date('2025-04-05T00:00:00Z'),
        end_time: new Date('2025-06-30T00:00:00Z'),
        created_at: new Date()
      },  */


/*        {
        title: 'Coffee Milk Tea Chocolate',
        image_url: 'https://res.cloudinary.com/dehehzz2t/image/upload/v1747154239/coffee-milk-tea_ychipe.png',
        action_type: 'PRODUCT',
        action_value: '7',
        product_id: null,
        category_id: null, // ID thật của danh mục (phải tồn tại trong DB)
        start_time: new Date('2025-04-05T00:00:00Z'),
        end_time: new Date('2025-06-30T00:00:00Z'),
        created_at: new Date()
      },  */


     // https://res.cloudinary.com/dehehzz2t/image/upload/v1747154239/coffee-milk-tea_ychipe.png


      //https://res.cloudinary.com/dehehzz2t/image/upload/v1747152642/0338498306_3_bafw9z.png
    ], {});
    
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
