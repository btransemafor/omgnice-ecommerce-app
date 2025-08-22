const { db } = require('../models/index.js');

// Lấy tất cả sản phẩm và biến thể
const getAllVariantProduct = async (callback) => {
  try {
    const variantProducts = await db.variantProduct.findAll({
      include: [
        {
          model: db.product,
          as: 'product', // Đảm bảo alias khớp với định nghĩa model
          attributes: ['id', 'name_product', 'imageUrl'],
        },
        {
          model: db.variant,
          as: 'variant',
          attributes: ['id', 'variant_name'],
        },
      ],
    });

    if (!variantProducts.length) {
      return callback(null, {
        success: false,
        message: 'Không tìm thấy sản phẩm hoặc biến thể nào.',
      });
    }

    // Nhóm theo sản phẩm
    const productMap = new Map();

    for (const item of variantProducts) {
      const product = item.product; // Chú ý chữ thường do alias
      const variant = item.variant;

      if (!productMap.has(product.id)) {
        productMap.set(product.id, {
          id: product.id,
          name_product: product.name_product,
          imageUrl: product.imageUrl,
          variants: [],
        });
      }

      productMap.get(product.id).variants.push({
        variant_id: variant.id,
        variant_name: variant.variant_name,
        price: item.price,
        discount_price: item.discount_price,
      });
    }

    const groupedProducts = Array.from(productMap.values());

    return callback(null, {
      success: true,
      message: 'Lấy danh sách sản phẩm và giá từng size thành công',
      data: groupedProducts,
    });
  } catch (error) {
    return callback({
      success: false,
      message: 'Lỗi khi lấy danh sách sản phẩm và biến thể',
      error: error.message,
    });
  }
};

// Lấy biến thể theo productId
const getVariantByProductId = async (productId, callback) => {
  try {
    // Kiểm tra sản phẩm tồn tại
    const product = await db.product.findOne({ where: { id: productId } });
    if (!product) {
      return callback(null, {
        success: false,
        message: 'Không tìm thấy sản phẩm.',
      });
    }

    const variantProducts = await db.variantProduct.findAll({
      where: { product_id: productId },
      include: [
        {
          model: db.product,
          as: 'product',
          attributes: ['id', 'name_product', 'imageUrl'],
        },
        {
          model: db.variant,
          as: 'variant',
          attributes: ['id', 'variant_name'],
        },
      ],
    });

    if (!variantProducts.length) {
      return callback(null, {
        success: false,
        message: 'Không tìm thấy biến thể cho sản phẩm này.',
      });
    }

    const variants = variantProducts.map((item) => ({
      variant_id: item.variant.id,
      variant_name: item.variant.variant_name,
      price: item.price,
      discount_price: item.discount_price,
    }));

    return callback(null, {
      success: true,
      message: 'Lấy thông tin sản phẩm và các biến thể thành công',
      data: {
        id: product.id,
        name_product: product.name_product,
        imageUrl: product.imageUrl,
        variants,
      },
    });
  } catch (error) {
    return callback({
      success: false,
      message: 'Lỗi khi lấy thông tin sản phẩm và biến thể',
      error: error.message,
    });
  }
};

// Lấy biến thể theo productId 
const getVariants = async (id, callback) => {
  try {
    // Kiểm tra sản phẩm tồn tại
    const product = await db.product.findOne({
      where: { id },
      attributes: ['id', 'name_product', 'imageUrl'],
    });

    if (!product) {
      return callback(null, {
        success: false,
        message: 'Không tìm thấy sản phẩm.',
      });
    }

    // Lấy danh sách biến thể
    const variantProducts = await db.variantProduct.findAll({
      where: { product_id: id },
      include: [
        {
          model: db.variant,
          as: 'variant',
          attributes: ['id', 'variant_name'],
        },
      ],
      attributes: ['id', 'price', 'discount_price', 'variant_id'],
    });

    if (!variantProducts.length) {
      return callback(null, {
        success: false,
        message: 'Không tìm thấy biến thể cho sản phẩm này.',
      });
    }

    // Ánh xạ dữ liệu biến thể
    const variants = variantProducts.map((item) => ({
      variant_id: item.variant.id,
      variant_name: item.variant.variant_name,
      price: item.price,
      discount_price: item.discount_price,
    }));

    return callback(null, {
      success: true,
      message: 'Lấy thông tin sản phẩm và các biến thể thành công',
      data: {
        id: product.id,
        name_product: product.name_product,
        imageUrl: product.imageUrl,
        variants,
      },
    });
  } catch (error) {
    return callback({
      success: false,
      message: 'Lỗi khi lấy thông tin biến thể',
      error: error.message,
    });
  }
};

module.exports = {
  getAllVariantProduct,
  getVariantByProductId,
  getVariants,
};