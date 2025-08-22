'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("category", null, {
      truncate: true, 
      cascade: true, 
      restartIdentity: true, 
    });

    await queryInterface.bulkInsert('category', [
      { category_name: 'Signature Milk Teas' },       // Trà Sữa Đặc Trưng
      { category_name: 'Fruit Infusions' },           // Trà Trái Cây Cao Cấp
      { category_name: 'Artisan Coffees' },           // Cà Phê Thủ Công
      { category_name: 'Pure Juices' },               // Nước Ép Nguyên Chất
      { category_name: 'Ice Blended Sensations' },    // Thức Uống Đá Xay
      { category_name: 'Gourmet Yogurts' },           // Sữa Chua Thượng Hạng
      { category_name: 'Sparkling Sodas' },           // Soda Cao Cấp
      { category_name: 'Specialty Drinks' },          // Thức Uống Đặc Biệt
      { category_name: 'Warm Comforts' },             // Đồ Uống Nóng
      { category_name: 'Exclusive Combos' }           // Combo Khuyến Mãi Độc Quyền
    ], {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('category', null, {});
  }
};
