/* const config = require("../config/db.config.js");
const sequelize = config.sequelize;
const Sequelize = require("sequelize");

// Load Models
const Role = require("./role.model");
const User = require("./user.model");
const UserOtp = require("./otpUser.model");
const Category = require("./category.model");
const Product = require("./product.model");
const Variant = require("./variant.model");
const VariantProduct = require("./variant_product.model");
const Address = require("./address.model");
const UserAddress = require("./user_address.model");
const Cart = require("./shopping_cart.model.js");
const CartItem = require("./cart_item.model");
const Review = require("./review.model");
const Order = require("./order.model");
const OrderLine = require("./order_line.model");
const ShippingMethod = require("./shipping_method.model.js");
const Promotion = require("./promotion.model.js");
const Banner = require("./banner.model.js");
const authToken = require("./authToken.model.js");
const userPromotion = require("./user_promotion.model.js");
const Payment = require("./payment.model");
const UserFavoriteProduct = require("./userFavoriteProduct.model.js");
const Notification = require('./notification.model.js'); 

// Init DB object
const db = {};

// Khởi tạo Sequelize và các model
db.sequelize = sequelize;
db.Sequelize = Sequelize;

// Khởi tạo tất cả các model trước
db.role = Role(sequelize, Sequelize);
db.user = User(sequelize, Sequelize);
db.otp = UserOtp(sequelize, Sequelize);
db.category = Category(sequelize, Sequelize);
db.product = Product(sequelize, Sequelize);
db.variant = Variant(sequelize, Sequelize);
db.variantProduct = VariantProduct(sequelize, Sequelize);
db.address = Address(sequelize, Sequelize);
db.userAddress = UserAddress(sequelize, Sequelize);
db.cart = Cart(sequelize, Sequelize);
db.cart_item = CartItem(sequelize, Sequelize);
db.review = Review(sequelize, Sequelize);
db.order = Order(sequelize, Sequelize);
db.order_line = OrderLine(sequelize, Sequelize);
db.shipping_method = ShippingMethod(sequelize, Sequelize);
db.promotion = Promotion(sequelize, Sequelize);
db.banner = Banner(sequelize, Sequelize);
db.authToken = authToken(sequelize, Sequelize);
db.userPromotion = userPromotion(sequelize, Sequelize);
db.payment = Payment(sequelize, Sequelize); // Đảm bảo Payment được khởi tạo
db.userFavorite = UserFavoriteProduct(sequelize, Sequelize);


db.notification = Notification(sequelize, Sequelize); 

db.notification.belongsTo(db.user, {foreignKey: "user_id", as: "user"}); 
db.user.hasMany(db.notification, {foreignKey: "user_id", as: "notifications"})

// Thiết lập các mối quan hệ sau khi tất cả model đã được khởi tạo

// userPromotion n-n
db.promotion.belongsToMany(db.user, {
  through: db.userPromotion,
  foreignKey: "promotion_id",
  otherKey: "user_id",
  as: "usersUsedPromotion",
});

db.user.belongsToMany(db.promotion, {
  through: db.userPromotion,
  foreignKey: "user_id",
  otherKey: "promotion_id",
  as: "usedPromotions",
});

// MQH vs user
db.authToken.belongsTo(db.user, { foreignKey: "user_id", as: "user" });
db.user.hasOne(db.authToken, { foreignKey: "user_id", as: "authToken" });

// Banner vẫn thuộc về Product và Category (belongsTo giữ nguyên)
db.banner.belongsTo(db.product, { foreignKey: "product_id", as: "product" });
db.banner.belongsTo(db.category, { foreignKey: "category_id", as: "category" });

// Sửa từ hasMany → hasOne
db.product.hasOne(db.banner, { foreignKey: "product_id", as: "banner" });
db.category.hasOne(db.banner, { foreignKey: "category_id", as: "banner" });

// Role – User (1-N)
db.role.hasMany(db.user, { foreignKey: "role_id", as: "users" });
db.user.belongsTo(db.role, { foreignKey: "role_id", as: "role" });
db.ROLES = ["user", "admin"];

// User – OTP (1-N)
db.user.hasMany(db.otp, {
  foreignKey: "user_id",
  as: "otps",
  onDelete: "CASCADE",
});
db.otp.belongsTo(db.user, { foreignKey: "user_id", as: "user" });

// Category – Product (1-N)
db.category.hasMany(db.product, { foreignKey: "category_id", as: "products" });
db.product.belongsTo(db.category, {
  foreignKey: "category_id",
  as: "category",
});

// Product – VariantProduct (1-N)
db.product.hasMany(db.variantProduct, {
  foreignKey: "product_id",
  as: "variantProducts",
});
db.variantProduct.belongsTo(db.product, {
  foreignKey: "product_id",
  as: "product",
});

// Variant – VariantProduct (1-N)
db.variant.hasMany(db.variantProduct, {
  foreignKey: "variant_id",
  as: "variantProducts",
});
db.variantProduct.belongsTo(db.variant, {
  foreignKey: "variant_id",
  as: "variant",
});

// User – Address (Many to Many)
db.user.belongsToMany(db.address, {
  through: db.userAddress,
  foreignKey: "user_id",
  otherKey: "address_id",
  as: "addresses",
});
db.address.belongsToMany(db.user, {
  through: db.userAddress,
  foreignKey: "address_id",
  otherKey: "user_id",
  as: "users",
});
db.user.hasMany(db.userAddress, { foreignKey: "user_id", as: "userAddresses" });
db.userAddress.belongsTo(db.user, { foreignKey: "user_id", as: "user" });

db.address.hasMany(db.userAddress, {
  foreignKey: "address_id",
  as: "userAddresses",
});
db.userAddress.belongsTo(db.address, {
  foreignKey: "address_id",
  as: "address",
});

// User – Cart (1-1)
db.user.hasOne(db.cart, { foreignKey: "user_id", as: "cart" });
db.cart.belongsTo(db.user, { foreignKey: "user_id", as: "user" });

// Cart – CartItem (1-N)
db.cart.hasMany(db.cart_item, { foreignKey: "cart_id", as: "cartItems" });
db.cart_item.belongsTo(db.product, { foreignKey: "product_id", as: "product" });
db.cart_item.belongsTo(db.cart, { foreignKey: "cart_id", as: "cart" });

// Variant – CartItem (1-N)
db.cart_item.belongsTo(db.variant, { foreignKey: "variant_id", as: "variant" });
db.variant.hasMany(db.cart_item, { foreignKey: "variant_id", as: "cartItems" });

// Cart – Variant (N - N) thông qua CartItem
db.cart.belongsToMany(db.variant, {
  through: db.cart_item,
  foreignKey: "cart_id",
  otherKey: "variant_id",
  as: "variants",
});
db.variant.belongsToMany(db.cart, {
  through: db.cart_item,
  foreignKey: "variant_id",
  otherKey: "cart_id",
  as: "carts",
});

// Review - Order_line
db.review.belongsTo(db.order_line, {
  foreignKey: "order_line_id",
  as: "orderLine",
});

db.order_line.hasOne(db.review, {
  foreignKey: "order_line_id",
  as: "review",
});

db.user.hasMany(db.review, {
  foreignKey: "user_id",
  as: "reviews", // <-- user -> nhiều review, nên alias phải là reviews
});

db.review.belongsTo(db.user, {
  foreignKey: "user_id",
  as: "user",
});

// User – Order (1-N)
db.user.hasMany(db.order, { foreignKey: "user_id", as: "orders" });
db.order.belongsTo(db.user, { foreignKey: "user_id", as: "user" });

// Order – OrderLine (1-N)
db.order.hasMany(db.order_line, { foreignKey: "order_id", as: "orderLines" });
db.order_line.belongsTo(db.order, { foreignKey: "order_id", as: "order" });

// OrderLine – Variant (N-1)
db.order_line.belongsTo(db.variant, {
  foreignKey: "variant_id",
  as: "variant",
});
db.variant.hasMany(db.order_line, {
  foreignKey: "variant_id",
  as: "orderLines",
});

// OrderLine – Product (N-1)
db.order_line.belongsTo(db.product, {
  foreignKey: "product_id",
  as: "product",
});

// Product – OrderLine (1-N)
db.product.hasMany(db.order_line, {
  foreignKey: "product_id",
  as: "orderLines",
});

// OrderLine vs VariantProduct
db.order_line.belongsTo(db.variantProduct, {
  foreignKey: "variant_product_id",
  as: "variantProduct",
});
db.variantProduct.hasMany(db.order_line, {
  foreignKey: "variant_product_id",
  as: "orderLines",
});

// Shipping_method vs Order
db.order.belongsTo(db.shipping_method, {
  foreignKey: "shipping_method_id",
  as: "shippingMethod",
});

// Promotion vs Order (1-N)
db.promotion.hasMany(db.order, { foreignKey: "promotion_id", as: "orders" });
db.order.belongsTo(db.promotion, {
  foreignKey: "promotion_id",
  as: "promotion",
});

// Order vs UserAddress
db.order.belongsTo(db.userAddress, {
  foreignKey: "address_id",
  targetKey: "id",
  as: "userAddress",
});
db.userAddress.hasMany(db.order, {
  foreignKey: "address_id",
  sourceKey: "id",
  as: "orders",
});

// Promotion vs Product/Category
db.promotion.belongsTo(db.product, {
  foreignKey: "product_id",
  as: "product",
});
db.promotion.belongsTo(db.category, {
  foreignKey: "category_id",
  as: "category",
});

// User – Product (Many-to-Many) thông qua UserFavoriteProduct
db.user.belongsToMany(db.product, {
  through: db.userFavorite,
  foreignKey: "user_id",
  otherKey: "product_id",
  as: "favorite_products",
});
db.product.belongsToMany(db.user, {
  through: db.userFavorite,
  foreignKey: "product_id",
  otherKey: "user_id",
  as: "favorited_by_users",
});

// Order – Payment (1-1)
db.order.belongsTo(db.payment, {
  foreignKey: "paymentId",
  as: "payment",
});
db.payment.hasOne(db.order, {
  foreignKey: "paymentId",
  as: "order",
});

const syncDB = async () => {
  try {
    db.sequelize.sync({ alter: true }).then(() => {
      console.log("Database synced successfully!");
      initial(); // Optional seed
    });
  } catch (error) {
    console.error("Error syncing database:", error);
  }
};

async function initial() {
  // Seed initial roles or other data if needed
}

module.exports = { sequelize, syncDB, db };
 */







const config = require("../config/db.config.js");
const sequelize = config.sequelize;
const Sequelize = require("sequelize");

// Load Models
const Role = require("./role.model");
const User = require("./user.model");
const UserOtp = require("./otpUser.model");
const Category = require("./category.model");
const Product = require("./product.model");
const Variant = require("./variant.model");
const VariantProduct = require("./variant_product.model");
const Address = require("./address.model");
const UserAddress = require("./user_address.model");
const Cart = require("./shopping_cart.model.js");
const CartItem = require("./cart_item.model");
const Review = require("./review.model");
const Order = require("./order.model");
const OrderLine = require("./order_line.model");
const ShippingMethod = require("./shipping_method.model.js");
const Promotion = require("./promotion.model.js");
const Banner = require("./banner.model.js");
const authToken = require("./authToken.model.js");
const userPromotion = require("./user_promotion.model.js");
const Payment = require("./payment.model");
const UserFavoriteProduct = require("./userFavoriteProduct.model.js");
const Notification = require('./notification.model.js'); 
const AdminNotification = require('./admin_noti.model.js')

// Init DB object
const db = {};

// Khởi tạo Sequelize và các model
db.sequelize = sequelize;
db.Sequelize = Sequelize;

// Khởi tạo tất cả các model trước
db.role = Role(sequelize, Sequelize);
db.user = User(sequelize, Sequelize);
db.otp = UserOtp(sequelize, Sequelize);
db.category = Category(sequelize, Sequelize);
db.product = Product(sequelize, Sequelize);
db.variant = Variant(sequelize, Sequelize);
db.variantProduct = VariantProduct(sequelize, Sequelize);
db.address = Address(sequelize, Sequelize);
db.userAddress = UserAddress(sequelize, Sequelize);
db.cart = Cart(sequelize, Sequelize);
db.cart_item = CartItem(sequelize, Sequelize);
db.review = Review(sequelize, Sequelize);
db.order = Order(sequelize, Sequelize);
db.order_line = OrderLine(sequelize, Sequelize);
db.shipping_method = ShippingMethod(sequelize, Sequelize);
db.promotion = Promotion(sequelize, Sequelize);
db.banner = Banner(sequelize, Sequelize);
db.authToken = authToken(sequelize, Sequelize);
db.userPromotion = userPromotion(sequelize, Sequelize);
db.payment = Payment(sequelize, Sequelize);
db.userFavorite = UserFavoriteProduct(sequelize, Sequelize);
db.notification = Notification(sequelize, Sequelize); 
db.adminNoti = AdminNotification(sequelize,Sequelize);

// ============== ASSOCIATIONS WITH CASCADE DELETE FOR USER ============== 

// Notification - User (N-1) - CASCADE DELETE
db.notification.belongsTo(db.user, {
  foreignKey: "user_id", 
  as: "user",
  onDelete: "CASCADE"
}); 
db.user.hasMany(db.notification, {
  foreignKey: "user_id", 
  as: "notifications",
  onDelete: "CASCADE"
});

// Role – User (1-N) - SET NULL when role deleted, but CASCADE when user deleted
db.role.hasMany(db.user, { 
  foreignKey: "role_id", 
  as: "users" 
});
db.user.belongsTo(db.role, { 
  foreignKey: "role_id", 
  as: "role",
  onDelete: "SET NULL" // Không xóa user khi xóa role
});
db.ROLES = ["user", "admin"];

// User – OTP (1-N) - CASCADE DELETE
db.user.hasMany(db.otp, {
  foreignKey: "user_id",
  as: "otps",
  onDelete: "CASCADE",
});
db.otp.belongsTo(db.user, { 
  foreignKey: "user_id", 
  as: "user",
  onDelete: "CASCADE"
});

// AuthToken - User (1-1) - CASCADE DELETE
db.authToken.belongsTo(db.user, { 
  foreignKey: "user_id", 
  as: "user",
  onDelete: "CASCADE"
});
db.user.hasOne(db.authToken, { 
  foreignKey: "user_id", 
  as: "authToken",
  onDelete: "CASCADE"
});

// User – Cart (1-1) - CASCADE DELETE
db.user.hasOne(db.cart, { 
  foreignKey: "user_id", 
  as: "cart",
  onDelete: "CASCADE"
});
db.cart.belongsTo(db.user, { 
  foreignKey: "user_id", 
  as: "user",
  onDelete: "CASCADE"
});

// User – Order (1-N) - CASCADE DELETE
db.user.hasMany(db.order, { 
  foreignKey: "user_id", 
  as: "orders",
  onDelete: "CASCADE"
});
db.order.belongsTo(db.user, { 
  foreignKey: "user_id", 
  as: "user",
  onDelete: "CASCADE"
});

// User – Review (1-N) - CASCADE DELETE
db.user.hasMany(db.review, {
  foreignKey: "user_id",
  as: "reviews",
  onDelete: "CASCADE"
});
db.review.belongsTo(db.user, {
  foreignKey: "user_id",
  as: "user",
  onDelete: "CASCADE"
});

// User – Address (Many to Many) - CASCADE DELETE for junction table
db.user.belongsToMany(db.address, {
  through: db.userAddress,
  foreignKey: "user_id",
  otherKey: "address_id",
  as: "addresses",
  onDelete: "CASCADE"
});
db.address.belongsToMany(db.user, {
  through: db.userAddress,
  foreignKey: "address_id",
  otherKey: "user_id",
  as: "users"
});

// Direct associations for UserAddress - CASCADE DELETE
db.user.hasMany(db.userAddress, { 
  foreignKey: "user_id", 
  as: "userAddresses",
  onDelete: "CASCADE"
});
db.userAddress.belongsTo(db.user, { 
  foreignKey: "user_id", 
  as: "user",
  onDelete: "CASCADE"
});

db.address.hasMany(db.userAddress, {
  foreignKey: "address_id",
  as: "userAddresses"
});
db.userAddress.belongsTo(db.address, {
  foreignKey: "address_id",
  as: "address"
});

// User – Promotion (Many to Many) - CASCADE DELETE for junction table  
db.promotion.belongsToMany(db.user, {
  through: db.userPromotion,
  foreignKey: "promotion_id",
  otherKey: "user_id",
  as: "usersUsedPromotion"
});

db.user.belongsToMany(db.promotion, {
  through: db.userPromotion,
  foreignKey: "user_id",
  otherKey: "promotion_id",
  as: "usedPromotions",
  onDelete: "CASCADE"
});

// User – Product Favorites (Many-to-Many) - CASCADE DELETE for junction table
db.user.belongsToMany(db.product, {
  through: db.userFavorite,
  foreignKey: "user_id",
  otherKey: "product_id",
  as: "favorite_products",
  onDelete: "CASCADE"
});
db.product.belongsToMany(db.user, {
  through: db.userFavorite,
  foreignKey: "product_id",
  otherKey: "user_id",
  as: "favorited_by_users"
});

// ============== OTHER ASSOCIATIONS (NON-USER RELATED) ==============

// Banner associations
db.banner.belongsTo(db.product, { foreignKey: "product_id", as: "product" });
db.banner.belongsTo(db.category, { foreignKey: "category_id", as: "category" });
db.product.hasOne(db.banner, { foreignKey: "product_id", as: "banner" });
db.category.hasOne(db.banner, { foreignKey: "category_id", as: "banner" });

// Category – Product (1-N)
db.category.hasMany(db.product, { foreignKey: "category_id", as: "products" });
db.product.belongsTo(db.category, {
  foreignKey: "category_id",
  as: "category",
});

// Product – VariantProduct (1-N)
db.product.hasMany(db.variantProduct, {
  foreignKey: "product_id",
  as: "variantProducts",
});
db.variantProduct.belongsTo(db.product, {
  foreignKey: "product_id",
  as: "product",
});

// Variant – VariantProduct (1-N)
db.variant.hasMany(db.variantProduct, {
  foreignKey: "variant_id",
  as: "variantProducts",
});
db.variantProduct.belongsTo(db.variant, {
  foreignKey: "variant_id",
  as: "variant",
});

// Cart – CartItem (1-N) - CASCADE DELETE when cart deleted
db.cart.hasMany(db.cart_item, { 
  foreignKey: "cart_id", 
  as: "cartItems",
  onDelete: "CASCADE"
});
db.cart_item.belongsTo(db.product, { foreignKey: "product_id", as: "product" });
db.cart_item.belongsTo(db.cart, { 
  foreignKey: "cart_id", 
  as: "cart",
  onDelete: "CASCADE"
});

// Variant – CartItem (1-N)
db.cart_item.belongsTo(db.variant, { foreignKey: "variant_id", as: "variant" });
db.variant.hasMany(db.cart_item, { foreignKey: "variant_id", as: "cartItems" });

// Cart – Variant (N - N) thông qua CartItem
db.cart.belongsToMany(db.variant, {
  through: db.cart_item,
  foreignKey: "cart_id",
  otherKey: "variant_id",
  as: "variants",
});
db.variant.belongsToMany(db.cart, {
  through: db.cart_item,
  foreignKey: "variant_id",
  otherKey: "cart_id",
  as: "carts",
});

// Review - Order_line
db.review.belongsTo(db.order_line, {
  foreignKey: "order_line_id",
  as: "orderLine",
});
db.order_line.hasOne(db.review, {
  foreignKey: "order_line_id",
  as: "review",
});

// Order – OrderLine (1-N) - CASCADE DELETE when order deleted
db.order.hasMany(db.order_line, { 
  foreignKey: "order_id", 
  as: "orderLines",
  onDelete: "CASCADE"
});
db.order_line.belongsTo(db.order, { 
  foreignKey: "order_id", 
  as: "order",
  onDelete: "CASCADE"
});

// OrderLine – Variant (N-1)
db.order_line.belongsTo(db.variant, {
  foreignKey: "variant_id",
  as: "variant",
});
db.variant.hasMany(db.order_line, {
  foreignKey: "variant_id",
  as: "orderLines",
});

// OrderLine – Product (N-1)
db.order_line.belongsTo(db.product, {
  foreignKey: "product_id",
  as: "product",
});
db.product.hasMany(db.order_line, {
  foreignKey: "product_id",
  as: "orderLines",
});

// OrderLine vs VariantProduct
db.order_line.belongsTo(db.variantProduct, {
  foreignKey: "variant_product_id",
  as: "variantProduct",
});
db.variantProduct.hasMany(db.order_line, {
  foreignKey: "variant_product_id",
  as: "orderLines",
});

// Shipping_method vs Order
db.order.belongsTo(db.shipping_method, {
  foreignKey: "shipping_method_id",
  as: "shippingMethod",
});

// Promotion vs Order (1-N)
db.promotion.hasMany(db.order, { foreignKey: "promotion_id", as: "orders" });
db.order.belongsTo(db.promotion, {
  foreignKey: "promotion_id",
  as: "promotion",
});

// Order vs UserAddress
db.order.belongsTo(db.userAddress, {
  foreignKey: "address_id",
  targetKey: "id",
  as: "userAddress",
});
db.userAddress.hasMany(db.order, {
  foreignKey: "address_id",
  sourceKey: "id",
  as: "orders",
});

// Promotion vs Product/Category
db.promotion.belongsTo(db.product, {
  foreignKey: "product_id",
  as: "product",
});
db.promotion.belongsTo(db.category, {
  foreignKey: "category_id",
  as: "category",
});

// Order – Payment (1-1)
db.order.belongsTo(db.payment, {
  foreignKey: "paymentId",
  as: "payment",
});
db.payment.hasOne(db.order, {
  foreignKey: "paymentId",
  as: "order",
});

const syncDB = async () => {
  try {
    db.sequelize.sync({ alter: true }).then(() => {
      console.log("Database synced successfully!");
      initial(); // Optional seed
    });
  } catch (error) {
    console.error("Error syncing database:", error);
  }
};

async function initial() {
  // Seed initial roles or other data if needed
}

module.exports = { sequelize, syncDB, db };