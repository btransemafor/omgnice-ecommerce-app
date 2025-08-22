// ================================
// syncProductsToPinecone.js (đã sửa lỗi)
// ================================
const { Op } = require('sequelize');
const { pinecone } = require('../utils/pineconeUtils');
const {db} = require('../models/index');
const Product = db.product;

const index = pinecone.index(process.env.PINECONE_INDEX_NAME);

async function syncProducts({ updatedSince = null, categoryId = null } = {}) {
  try {
    const where = {};
    if (updatedSince) where.updated_at = { [Op.gte]: new Date(updatedSince) };
    if (categoryId) where.category_id = categoryId;

    const products = await Product.findAll({
      where,
      include: [
        { model: db.category, as: 'category', attributes: ['category_name'] },
        {
          model: db.variantProduct,
          as: 'variantProducts',
          attributes: ['variant_id', 'price', 'discount_price'],
          include: [
            { model: db.variant, as: 'variant', attributes: ['variant_name'] }
          ]
        }
      ]
    });

    if (!products.length) {
      console.log('No products found for syncing.');
      return 0;
    }

    const data = [];

    for (const product of products) {
      const categoryName = product.category?.category_name || 'Không rõ';
      const variants = product.variantProducts.map(vp => ({
        id: vp.variant_id,
        name: vp.variant?.variant_name || 'Không rõ',
        price: vp.price,
        discount_price: vp.discount_price
      }));

      const averageRating = '5.0';

      const variantText = variants.map(v =>
        `Biến thể: ${v.name}, Giá: ${v.price} VND, Giá giảm: ${v.discount_price || v.price} VND`
      ).join('; ');

      const mainPrice = variants[0]?.discount_price || variants[0]?.price || 0;

      // 🛠 Sửa lỗi MÔ TẢ có thể bị null
      const description = product.description || 'Không có mô tả';

      const chunk_text = `Tên: ${product.name_product}. Mô tả: ${description}. Giá: ${mainPrice} VND. Danh mục: ${categoryName}. Đánh giá trung bình: ${averageRating}/5. Biến thể: ${variantText}. Giảm giá: ${product.discount_percent || 0}%.`;

      data.push({
        _id: `product_${product.id}`,
        chunk_text,
        category: categoryName,
        product_id: product.id
      });
    }


    const validData = data.filter(item => typeof item.chunk_text === 'string' && item.chunk_text.trim().length > 0);

    if (!validData.length) {
      console.log('Không có dữ liệu hợp lệ để upsert.');
      return 0;
    }

    const pineconeIndex = index.namespace('products');
    await pineconeIndex.upsertRecords(validData);

    console.log(` Synced ${validData.length} products to Pinecone.`);
    return validData.length;
  } catch (error) {
    console.error('Error in syncProducts:', error);
    throw error;
  }
}

module.exports = { syncProducts }
