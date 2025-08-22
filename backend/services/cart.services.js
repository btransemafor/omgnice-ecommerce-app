const { where } = require("sequelize");
const { db } = require("../models/index");
const { param } = require("../routes/cart.routes");

const Cart = db.cart;
const CartItem = db.cart_item;
const Variant = db.variant;
const VariantProduct = db.variantProduct;
const Product = db.product;

const getCartByUserid = async (user_id, callback) => {
  try {
    // Tìm giỏ hàng của người dùng
    const cart_user = await Cart.findOne({
      where: { user_id: user_id },
      attributes: ["id"],
      include: [
        {
          model: CartItem,
          as: "cartItems",
          attributes: ["id", "variant_id", "quantity", "note", "product_id"],
          include: [
            {
              model: Product,
              as: "product",
              attributes: ["id", "name_product", "imageUrl", "category_id"],
            },
            {
              model: Variant,
              as: "variant",
              attributes: ["variant_name", "id"],
              include: [
                {
                  model: VariantProduct,
                  as: "variantProducts",
                  attributes: ["price", "discount_price", "product_id"],
                },
              ],
            },
          ],
        },
      ],
      subQuery: false,
    });

    // Không tìm thấy giỏ hàng
    if (!cart_user) {
      return callback(null, { success: false, message: "Not Found Cart!" });
    }

    // Giỏ hàng rỗng
    if (!cart_user.cartItems || cart_user.cartItems.length === 0) {
      return callback(null, {
        success: false,
        message: "Not Found Item In Your Cart",
      });
    }

    // Duyệt qua từng CartItem
    const result = {
      success: true,
      cart_id: cart_user.id,
      cart_items: cart_user.cartItems.map((item) => {
        const variant = item.variant || {};
        const product = item.product || {
          name_product: "Unknown",
          imageUrl: "No image",
        };

        // ✅ Lọc đúng variantProduct theo product_id
        const variantProduct =
          (variant.variantProducts || []).find(
            (vp) => vp.product_id === item.product_id
          ) || {};

        return {
          cartitem_id: item.id,
          name_product: product.name_product,
          product_id: item.product_id, // This is using item.product_id, not product.id
          category_id: product.category_id, // This is using item.category_id, not product.category_id
          variant_id: variant.id,
          image_product: product.imageUrl,
          name_variant: variant.variant_name,
          price: variantProduct.price,
          discount_price: variantProduct.discount_price,
          quantity: item.quantity,
          note: item.note,
        };
      }),
    };

    callback(null, result);
  } catch (error) {
    callback(null, { success: false, message: error.message });
  }
};

// GetCart
//const getCart = async()

// Add To Cart
// Add To Cart
const addProductToCart = async (params, callback) => {
  try {
    const variant_name = params.variant_name;
    const quantity = params.quantity;
    const note = params.note || ""; // Ghi chú mặc định nếu không có
    const product_id = params.product_id;
    const user_id = params.user_id;

    // 📝 Bạn cần `await` ở đây vì `findOne` trả về `Promise`
    const cart = await db.cart.findOne({ where: { user_id: user_id } });

    if (!cart) {
      return callback(null, {
        success: false,
        message: "Cart not found for this user.",
      });
    }

    // 🔥 Lấy `cart_id` từ đối tượng `cart` đã được tìm thấy
    const cart_id = cart.id;

    // 🔍 Tìm Variant dựa theo tên Variant
    const variant = await db.variant.findOne({
      where: { variant_name: variant_name },
    });

    if (!variant) {
      return callback(null, {
        success: false,
        message: "Variant not found",
      });
    }

    const variant_id = variant.id;

    //  Tạo CartItem
    await db.cart_item.create({
      product_id: product_id,
      variant_id: variant_id,
      cart_id: cart_id,
      quantity: quantity,
      note: note,
    });

    return callback(null, {
      success: true,
      message: "Add to cart Successful",
    });
  } catch (error) {
    return callback(error);
  }
};

// -------------------- Delete Item Cart -------------------- //
// -------------------- Delete Item Cart -------------------- //
const deleteCartItem = async (cartItemId, callback) => {
  try {
    // Tìm sản phẩm trong giỏ hàng
    const cartItem = await db.cart_item.findOne({
      where: { id: cartItemId },
    });

    if (!cartItem) {
      return callback(null, {
        success: false,
        message: "Not found Item",
      });
    }

    // Thực hiện xóa sản phẩm khỏi giỏ hàng
    await cartItem.destroy();

    return callback(null, {
      success: true,
      message: "Delete item successfully",
    });
  } catch (error) {
    return callback(null, {
      success: false,
      message: "Error while deleting item: " + error.message,
    });
  }
};

const updateCart = async (dataUpdate, cartItemId, callback) => {
  try {
    // Tìm cart item theo ID
    const cartItem = await db.cart_item.findOne({
      where: { id: cartItemId },
    });

    // Nếu không tìm thấy
    if (!cartItem) {
      return callback(null, {
        success: false,
        message: "Not Found",
      });
    }

    // Cập nhật cart item
    await cartItem.update(dataUpdate);

    // Thành công
    return callback(null, {
      success: true,
      message: "Updated Item Cart Successfully",
    });
  } catch (error) {
    return callback(error);
  }
};

module.exports = {
  getCartByUserid,
  addProductToCart,
  deleteCartItem,
  updateCart,
};
