'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.bulkInsert(
      "product",
      [
   /*      {
          "id": 12,
          "name_product": "Classic Milk Tea",
          "description": "Classic Milk Tea blends strong black tea with creamy milk and a hint of sweetness, creating a timeless and comforting flavor. It's the go-to choice for milk tea lovers who crave the familiar and satisfying taste that never goes out of style.",
          "soldQuantity": 0,
          "stockQuantity": 100,
          "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1746114524/classic_milk_tea_jqkyrr.jpg",
          "category_id": 1,
          "discount_percent": 20
        },

        {
          "id": 13,
          "name_product": "Floral Jasmine Milk Tea",
          "description": "Floral Jasmine Milk Tea infuses delicate jasmine-scented green tea with creamy milk, delivering a soothing and aromatic experience. Light, floral, and refreshing, it's perfect for those who prefer a gentler, fragrant twist to traditional milk tea.",
          "soldQuantity": 0,
          "stockQuantity": 100,
          "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1746114524/Floral_Jasmine_Milk_Tea_Jasmine_Bubble_Tea_rwoa4o.jpg",
          "category_id": 1,
          "discount_percent": 10
        },

        {
          "id": 14,
          "name_product": "Matcha Milk Tea",
          "description": "Matcha Milk Tea features finely ground Japanese green tea powder blended with creamy milk. It offers a vibrant green color and a rich, earthy taste with a smooth, slightly bitter finish – a must-try for matcha enthusiasts.",
          "soldQuantity": 0,
          "stockQuantity": 100,
          "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1746114524/Matcha_Milk_Tea_fzb5le.jpg",
          "category_id": 1,
          "discount_percent": 0
        },

        {
          "id": 15,
          "name_product": "Pandan Coconut Milk Tea",
          "description": "Pandan Coconut Milk Tea brings together the fragrant aroma of pandan leaves with creamy coconut milk, creating a tropical and nostalgic flavor. Smooth, fragrant, and slightly nutty, it’s a unique twist on the milk tea tradition.",
          "soldQuantity": 0,
          "stockQuantity": 100,
          "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1746114570/Pandan_Coconut_Milk_Tea_u5k7xw.jpg",
          "category_id": 1,
          "discount_percent": 5
        },
        {
          "id": 16,
          "name_product": "Taro Bubble Tea",
          "description": "Taro Bubble Tea combines the nutty, vanilla-like flavor of taro root with creamy milk and chewy tapioca pearls. Its signature purple hue and sweet, mellow taste make it a fan favorite among bubble tea lovers.",
          "soldQuantity": 0,
          "stockQuantity": 100,
          "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1746114524/Taro_Bubble_Tea_Secrets_ntltql.jpg",
          "category_id": 1,
          "discount_percent": 20
        }, 
 */


/*       
  {
    "id": 17,
    "name_product": "Watermelon Cooler",
    "description": "A refreshing blend of ripe watermelon juice, fresh mint, and a splash of lime. Perfect for sunny days, this cooler brings a burst of hydrating sweetness with a cooling finish.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747156915/lemon_l40bai.jpg",
    "category_id": 10,
    "discount_percent": 15
  },
  {
    "id": 18,
    "name_product": "Strawberry Smoothie",
    "description": "Made with handpicked strawberries, creamy yogurt, and a hint of honey, this smoothie offers a naturally sweet and tangy flavor that’s both satisfying and energizing.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747156915/Strawberry_RaspberrySmoothie_lguc1k.jpg",
    "category_id": 10,
    "discount_percent": 10
  },
  {
    "id": 19,
    "name_product": "Lime Mint Fizz",
    "description": "A zesty combination of lime juice, soda water, and fresh mint leaves. This fizzy drink delivers a crisp and invigorating taste, perfect for a midday refresh.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747156915/chanh_jjfh1e.jpg",
    "category_id": 10,
    "discount_percent": 0
  },
  {
    "id": 20,
    "name_product": "Avocado Milkshake",
    "description": "Smooth and creamy, this avocado milkshake is blended with fresh milk and just the right touch of sweetness. A nourishing and indulgent treat that’s rich in flavor and nutrients.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747156914/avocado_smoothie_fx7uj3.jpg",
    "category_id": 10,
    "discount_percent": 20
  }, 
    {
    "id": 21,
    "name_product": "Berry Cocoa Delight",
    "description": "A cozy blend of rich hot cocoa topped with velvety whipped cream and a drizzle of berry sauce. Finished with fresh strawberries and blueberries, this drink is perfect for chilly days by the fire.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747158106/Dessert_wl4co5.jpg",
    "category_id": 10,
    "discount_percent": 25
  }, 
 */
   {
    "id": 22,
    "name_product": "Berry Lemonade Sparkler",
    "description": "A dazzling blend of vibrant berries, zesty lemon, and sparkling bubbles—this refreshing drink is your perfect pick-me-up! Whether you're hosting a lively party or enjoying a solo moment of bliss.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747160431/Cranberry_Sprizer_kelbmm.jpg",
    "category_id": 7,
    "discount_percent": 10
  },
  {
    "id": 23,
    "name_product": "Iced Lavender Green Tea",
    "description": "Refresh your body and soothe your mind with the calming fusion of lavender and green tea. This fragrant, chilled delight balances floral serenity with earthy green tea, creating the perfect escape in every sip.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747159537/Lime_Basil_Elixir_Mocktail_Rezept_ft7dps.jpg",
    "category_id": 7,
    "discount_percent": 10
  },
  {
    "id": 27,
    "name_product": "Green Apple Detox",
    "description": "Kickstart your day with a refreshing blend of crisp green apples and detoxifying ingredients. Packed with nutrients and zesty goodness, this smoothie is the perfect way to recharge and fuel your body.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747159848/green_app_detox_o91ziu.jpg",
    "category_id": 7,
    "discount_percent": 0
  },
  {
    "id": 24,
    "name_product": "Cucumber Mint Detox Water",
    "description": "Stay cool, refreshed, and hydrated with the crisp fusion of cucumber and mint. This light and invigorating detox water boosts wellness and hydration with every sip.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747159947/Cucumber_Mint_Cooler_fs0ynq.jpg",
    "category_id": 7,
    "discount_percent": 0
  },
  {
    "id": 25,
    "name_product": "Avocado Mint Fusion",
    "description": "Indulge in the creamy, refreshing blend of velvety avocado and cool mint! This fusion is nourishing and smooth—balancing richness and freshness in every sip.",
    "soldQuantity": 7,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747160028/Avocado_Mint_Fusion__A_Creamy_flnp95.jpg",
    "category_id": 1,
    "discount_percent": 0
  },
  {
    "id": 4,
    "name_product": "Passionfruit Mango Sparkler",
    "description": "A dazzling blend of tropical passionfruit and sweet mango, infused with sparkling bubbles for a refreshing burst of flavor! Light, fizzy, and perfect for a tropical escape.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747160100/Passionfruit_Mango_Sparkler_hyzngz.jpg",
    "category_id": 7,
    "discount_percent": 0
  },
  {
    "id": 26,
    "name_product": "Pineapple Watermelon Punch",
    "description": "A tropical fusion of juicy watermelon and golden pineapple, bursting with sweet, refreshing flavor! Perfect for summer days and full of fruity delight.",
    "soldQuantity": 0,
    "stockQuantity": 100,
    "imageUrl": "https://res.cloudinary.com/dehehzz2t/image/upload/v1747160192/Pineapple_Watermelon_Punch_nwg4jj.jpg",
    "category_id": 7,
    "discount_percent": 0
  }

]
      )
    
    /**
     * Add seed commands here.
     *
     * Example:
     * await queryInterface.bulkInsert('People', [{
     *   name: 'John Doe',
     *   isBetaMember: false
     * }], {});
    */
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
