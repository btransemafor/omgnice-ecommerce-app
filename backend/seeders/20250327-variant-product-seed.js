"use strict";

module.exports = {
  async up(queryInterface, Sequelize) {
    // Xoá dữ liệu cũ
/*     await queryInterface.bulkDelete("variant_product", null, {
      truncate: true,
      cascade: true,
      restartIdentity: true,
    });
 */
    // Seed variant_product (10 sản phẩm, mỗi sản phẩm có 3 size)
    const seedData = [];

    // Danh sách giá cho 10 sản phẩm (theo thứ tự)
    const prices = [
 /*      [25000, 38000, 43000],
      [20000, 35000, 56000],
      [27000, 34000, 41000],
      [31000, 36000, 47000],
      [29500, 36500, 48000],

      [28500, 33000, 44500],
      [27000, 34000, 41000],
      [31000, 36000, 47000],
      [29500, 50500, 60000],
      [28500, 40000, 100500],

      [50000, 75000, 125000],
      [31000, 36000, 47000],
      [29500, 36500, 48000],
      [28500, 33000, 77500],
      [27000, 34000, 49000], */

      [31000, 36000, 47000],
      [29500, 36500, 48000],
      [28500, 33000, 77500],
       [57000, 69000, 99000]

/* 
      [31000, 46000, 65000],
      [120000, 155000, 210000], // product_id = 1
      [99000, 122000, 145000],
      [75000, 100000, 170000],
      [120000, 110000, 155000],

      [79000, 95000, 112000], */
    ];

    for (let i = 0; i < prices.length; i++) {
  const productId = i + 28; // Bắt đầu từ product_id = 27
  const [priceS, priceM, priceL] = prices[i];

  seedData.push(
    {
      product_id: productId,
      variant_id: 1,
      price: priceS,
      discount_price: priceS - 2000,
    },
    {
      product_id: productId,
      variant_id: 2,
      price: priceM,
      discount_price: priceM - 2000,
    },
    {
      product_id: productId,
      variant_id: 3,
      price: priceL,
      discount_price: priceL - 2000,
    }
  );
}


    await queryInterface.bulkInsert("variant_product", seedData, {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("variant_product", null, {});
  },
};
