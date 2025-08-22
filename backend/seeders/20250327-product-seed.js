"use strict";

module.exports = {
  async up(queryInterface, Sequelize) {
    // 🧨 Xoá sạch dữ liệu cũ trước khi thêm mới
    // await queryInterface.bulkDelete("product", null, {
    //   truncate: true,
    //   cascade: true,
    //   restartIdentity: true,
    // });

    await queryInterface.bulkInsert(
      "product",
      [
      /*   { 
          id: 1, 
          name_product: "Frosted Espresso With Caramel Drizzle",
          description: "Frosted Espresso With Caramel Drizzle is a rich and refreshing blended coffee drink. Bold espresso is chilled and whipped with ice and a touch of creamy milk, creating a smooth, frosty texture. It’s topped off with a generous drizzle of golden caramel sauce, adding a sweet, buttery finish to every sip. Perfect for coffee lovers who crave a cool, energizing treat with a touch of indulgence.",
          soldQuantity: 0,
          stockQuantity: 1000,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744273637/Frosted_Espresso_With_Caramel_Drizzle_cikiww.jpg",
          category_id: 3,
          discount_percent: 10,
        },
        {
          id: 2,
          name_product: "Hazelnut Tiramisu Cold Brew with Dark Chocolate Dust",
          description: "Hazelnut Tiramisu Cold Brew with Dark Chocolate Dust is a decadent twist on your classic cold brew. Smooth, slow-steeped coffee meets the rich flavor of hazelnut and the creamy essence of tiramisu. Each sip is velvety, subtly sweet, and perfectly balanced. Finished with a light dusting of dark chocolate on top, this drink delivers a hint of indulgence with every cool, caffeinated moment. A perfect pick-me-up for dessert lovers and coffee fans alike.",
          soldQuantity: 0,
          stockQuantity: 100,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744273775/Hazelnut_Tiramisu_Cold_Brew_with_Dark_Chocolate_Dust_f5yttu.jpg",
          category_id: 3,
          discount_percent: 0,
        },
        {
          id: 3,
          name_product: "Layered Espresso With Cinnamon Dust",
          description: "Layered Espresso With Cinnamon Dust is a visually stunning and flavorful coffee experience. Bold espresso is carefully poured over creamy milk to create beautiful, distinct layers. Each sip brings a balance of rich coffee and smooth texture, topped with a delicate sprinkle of aromatic cinnamon dust for a warm, spicy finish. It’s a simple yet elegant drink that awakens your senses.",
          soldQuantity: 0,
          stockQuantity: 100,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744273862/Layered_Espresso_With_Cinnamon_Dust_xkdjan.jpg",
          category_id: 3,
          discount_percent: 0,
        },
        {
          id: 4,
          name_product: "Salted Miso Caramel Latte with Vanilla Bean",
          description: "Salted Miso Caramel Latte with Vanilla Bean is a bold and luxurious fusion of flavors. Silky espresso is blended with creamy steamed milk, infused with rich vanilla bean, and elevated by a unique twist of salted miso caramel. The miso adds a subtle umami depth, balancing the sweetness of the caramel with a savory edge. It’s finished with a light swirl of caramel and a hint of vanilla aroma — a sophisticated latte for those who love something a little daring, a little different.",
          soldQuantity: 0,
          stockQuantity: 1000,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744274061/Salted_Miso_Caramel_Latte_with_Vanilla_Bean_ywaya4.jpg",
          category_id: 3,
          discount_percent: 0,
        },
        {
          id: 5,
          name_product: "Salted Caramel Frappe",
          description: "Salted Caramel Frappe is a creamy, icy blend of bold coffee, velvety milk, and rich caramel, finished with a hint of sea salt for the perfect sweet-and-salty balance. Topped with whipped cream and a golden caramel drizzle, this refreshing treat is indulgent, cool, and made to satisfy your cravings anytime.",
          soldQuantity: 0,
          stockQuantity: 400,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744274836/_Salted_Caramel_Frappe_zlh88x.jpg",
          category_id: 3,
          discount_percent: 0,
        },
        {
          id: 6,
          name_product: "Honey Cinnamon Ristretto",
          description: "Honey Cinnamon Ristretto is a bold yet comforting espresso shot with a twist. This short, intense ristretto is sweetened naturally with golden honey and finished with a sprinkle of warm cinnamon. The result? A smooth, aromatic shot that balances rich coffee depth with subtle sweetness and a cozy spice kick. Small in size, big on flavor.",
          soldQuantity: 0,
          stockQuantity: 999,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744275288/Honey_Cinnamon_Ristretto_agwhcm.jpg",
          category_id: 3,
          discount_percent: 0,
        },
        {
          id: 7,
          name_product: "Berry Yogurt Parfait",
          description: "A delightful and refreshing layered treat, this Berry Yogurt Parfait combines creamy vanilla yogurt with juicy, fresh berries and crunchy granola. Each spoonful offers the perfect balance of sweetness and tartness from strawberries, blueberries, and raspberries, nestled between smooth, chilled yogurt and wholesome granola clusters. Perfect for breakfast, a midday snack, or a light dessert — it's a healthy indulgence that's as beautiful as it is tasty.",
          soldQuantity: 0,
          stockQuantity: 1000,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744877596/Berry-Yogurt-Parfait_tapldg.jpg",
          category_id: 6,
          discount_percent: 10,
        },
        {
          id: 8, 
          name_product: "Blueberry Lemon Cheesecake Overnight Oats",
          description: "A luscious fusion of zesty lemon and sweet, juicy blueberries, this Blueberry Lemon Cheesecake is the ultimate dessert indulgence. Smooth and creamy cheesecake sits atop a buttery graham cracker crust, infused with a bright hint of lemon for a refreshing twist. Swirls of blueberry compote ripple through the rich filling, adding bursts of fruity flavor in every bite. Topped with a glossy layer of blueberry topping and a sprinkle of lemon zest, this dessert is both elegant and irresistible — perfect for any occasion.",
          soldQuantity: 0,
          stockQuantity: 100,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744878080/Blueberry_Lemon_Cheesecake_Overnight_Oats_iw20qq.jpg",
          category_id: 6,
          discount_percent: 0,
        },
        {
          id: 9,
          name_product: "Chia Pudding with Strawberries",
          description: "A light and nourishing treat, this Chia Pudding with Strawberries is as satisfying as it is wholesome. Creamy chia seed pudding, soaked overnight in silky almond or coconut milk, creates a smooth, pudding-like texture that’s naturally rich in fiber and omega-3s. Topped with fresh, juicy strawberries and a drizzle of honey or maple syrup, it’s the perfect balance of health and flavor. Ideal for breakfast, a snack, or a guilt-free dessert.",
          soldQuantity: 0,
          stockQuantity: 100,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744878964/Chia_Pudding_with_Strawberries_dpo5kd.jpg",
          category_id: 6,
          discount_percent: 0,
        },
        {
          id: 10, 
          name_product: "Blueberry Raspberry Smoothie",
          description: "Bursting with bold berry flavor, this Blueberry Raspberry Smoothie is a refreshing blend of ripe blueberries, tangy raspberries, and creamy yogurt or plant-based milk. Naturally sweet and rich in antioxidants, it's the perfect pick-me-up for busy mornings or post-workout fuel. Smooth, vibrant, and deliciously fruity, every sip is a taste of summer in a glass.",
          soldQuantity: 0,
          stockQuantity: 1000,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744879625/Blueberry_Raspberry_Smoothie_hibwyh.jpg",
          category_id: 6,
          discount_percent: 0,
        },


        {
          id : 11, 
          name_product: "Low-Carb Watermelon, Lime & Mint Juice",
          description: "Cool, crisp, and naturally refreshing — this summer juice blends sweet watermelon, zesty lime, and fresh mint into a light, low-carb drink that’s bursting with flavor. Hydrating and guilt-free, it’s the perfect way to stay refreshed and energized on hot days",
          soldQuantity: 10,
          stockQuantity: 1000,
          imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1744881800/Low-Carb_Watermelon_Lime_and_Mint_Summer_Juice_qegygc.png",
          category_id: 4,
          discount_percent: 0,
        },
   
 */



        {
  id: 28,
  name_product: "Raspberry Rose Lime Detox Water",
  description: "This refreshing detox water is a delicate blend of sweet raspberries, zesty lime slices, and fragrant rose petals. The vibrant pink hue comes naturally from the raspberries, while the lime adds a tangy citrus twist. Fresh rose petals not only give it a romantic touch but also provide subtle floral notes, making each sip feel luxurious and calming. Perfect for hydrating your body, cleansing your system, and elevating your mood.",
  soldQuantity: 2,
  stockQuantity: 1000,
  imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1747296764/Raspberry-Rose-Lime-Detox-Water_punxng.jpg",
  category_id: 2,
  discount_percent: 10
},
{
  id: 29,
  name_product: "Christmas Crisp Winter Citrus Mint Water Infusion",
  description: "This refreshing Christmas Crisp Winter Citrus Mint Water Infusion is a beautiful and healthy festive drink perfect for the holiday season. It's made by infusing fresh citrus slices, mint leaves, and seasonal ingredients in chilled water, creating a naturally flavored drink that is both hydrating and full of aroma.",
  soldQuantity: 2,
  stockQuantity: 1000,
  imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1747296963/Christmas_Crisp_Winter_Citrus_Mint_Water_Infusion_-_tf2rop.jpg",
  category_id: 2,
  discount_percent: 35
},
{
  id: 30,
  name_product: "Cucumber Melon Agua Fresca (No Added Sugar)",
  description: "A naturally refreshing drink that combines the cool crispness of cucumber with the subtle sweetness of melon. Light, hydrating, and perfect for warm days, this agua fresca is smooth, soothing, and completely free of added sugar. Enjoy a clean, vibrant taste with every sip.",
  soldQuantity: 2,
  stockQuantity: 1000,
  imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1747297208/Cucumber_Melon_Agua_Fresca_-_Spoonful_of_Plants_avao15.jpg",
  category_id: 2,
  discount_percent: 25
},
{
  id: 31,
  name_product: "Watermelon Pucker Cocktail",
  description: "A bold and juicy cocktail bursting with sweet watermelon flavor and a tangy twist. Lightly tart, irresistibly fun, and refreshingly smooth, this vibrant pink drink is perfect for summer parties or a playful night in. Sip, smile, and enjoy the fruity punch with a lip-smacking finish.",
  soldQuantity: 2,
  stockQuantity: 1000,
  imageUrl: "https://res.cloudinary.com/dehehzz2t/image/upload/v1747297771/Watermelon_Pucker_Cocktail_Recipe_na2zk9.jpg",
  category_id: 2,
  discount_percent: 15
}

      ],
      {}
    );
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete("product", null, {});
  },
};
