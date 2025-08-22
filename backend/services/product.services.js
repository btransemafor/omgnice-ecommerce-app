const { db } = require("../models/index.js");
const Product = db.product;
const { Op } = require("sequelize"); // Đã sửa lỗi này
const asyncService = require("./sync.services.js");
// ------------------------- Lay Tat ca san pham -------------------------- //
const { Sequelize } = require("sequelize");

const getAllProducts = async (callback) => {
  try {
    const products = await Product.findAll({
      where: {
        isHidden: false,
      },
    });
    return callback(null, {
      success: true,
      message: "Get All Product Successfully.",
      data: products,
    });
  } catch (error) {
    return callback(error);
  }
};

// ----------------------- Them --------------------------- //
// /:id
const updateProduct = async (param, callback) => {
  try {
    const id = param.id;
    const updateProductData = param.updateProductData;
    console.log(updateProductData);
    console.log(id);

    // Kiểm tra sản phẩm có tồn tại không
    const product = await Product.findOne({ where: { id } });
    if (!product) {
      return callback(null, {
        success: false,
        message: `Không tìm thấy sản phẩm với ID: ${id}`,
      });
    }

    // Cập nhật sản phẩm
    const [affectedRows] = await Product.update(updateProductData, {
      where: { id },
    });

    if (affectedRows === 0) {
      return callback(null, {
        success: false,
        message: "Không có thay đổi nào được thực hiện",
      });
    }

    return callback(null, {
      success: true,
      message: "Cập nhật sản phẩm thành công",
    });
  } catch (error) {
    return callback(error);
  }
};

// ----------------------------- delete product --------------------------- //
const deteleProduct = async (id, callback) => {
  try {
    // Check ton tai
    const product = await Product.findOne({ where: { id } });
    if (!product) {
      return callback(null, { message: "Not Found Product !", success: false }); // 404
    }

    await Product.destroy({ where: { id } });

    await db.variantProduct.destroy({ where: { product_id: id } });
    await asyncService.syncProducts();
    return callback(null, {
      success: true,
      message: "Delete product Successfully!",
    });
  } catch (error) {
    return callback(error);
  }
};

// ------------------------------ Them Mot San Pham -------------------------- //
const addProduct = async (param, callback) => {
  // Khong duoc trung ten

  try {
    const existingProductName = await Product.findOne({
      where: { name_product: param.name_product },
    });

    if (existingProductName) {
      callback(null, {
        success: false,
        message: `Tên sản phẩm đã tồn tại ${existingProductName.id}`,
      });
    }
    //await Product.create({ param, });

    const newProduct = await Product.create(param); // Truyen truc tiep param

    // Gọi sync ngay sau khi thêm
    await asyncService.syncProducts({ updatedSince: newProduct.updated_at });

    return callback(null, {
      success: true,
      message: "Thêm Sản phẩm thành công",
      data: param,
    }); // 201
  } catch (error) {
    return callback(error);
  }
};

// -------------------- GET PRODUCT BY CATEGPRY ----------------------- //

const getProductByCategorys = async (category_id, callback) => {
  try {
    const products = await db.product.findAll({
      where: { category_id },
      include: [
        {
          model: db.variantProduct,
          attributes: ["variant_id", "price", "discount_price"],
          include: [
            {
              model: db.variant,
              attributes: ["variant_name"],
            },
          ],
        },
      ],
    });

    //  Xử lý toàn bộ danh sách sản phẩm
    const result = products.map((product) => {
      const variants = product.VariantProducts.map((vp) => ({
        id: vp.variant_id,
        name_variant: vp.Variant?.variant_name || null,
        price: vp.price,
        discount_price: vp.discount_price,
      }));

      const calculateRating = calculateRating(product.id);

      return {
        id: product.id,
        soldQuantity: product.soldQuantity || 0,
        imageUrl: product.imageUrl,
        discount_percent: product.discount_percent || 0,
        name: product.name_product,
        description: product.description,
        categoryId: product.category_id,
        averageRating: calculateRating,
        variants: variants,
      };
    });

    return callback(null, {
      success: true,
      message: "Lấy danh sách sản phẩm theo danh mục thành công",
      data: result,
    });
  } catch (error) {
    console.error("Error in getProductByCategorys:", error);
    return callback(error);
  }
};

// ===========================================================
const getProductByCategory = async (category_id, callback) => {
  try {
    const products = await db.product.findAll({
      where: { category_id, isHidden: false },
      include: [
        {
          model: db.variantProduct,
          as: "variantProducts",
          attributes: ["variant_id", "price", "discount_price"],
          include: [
            {
              model: db.variant,
              as: "variant",
              attributes: ["variant_name"],
            },
          ],
        },
      ],
    });

    // Process all products and calculate ratings
    const result = await Promise.all(
      products.map(async (product) => {
        const variants = product.variantProducts.map((vp) => ({
          id: vp.variant_id,
          name_variant: vp.variant?.variant_name || null,
          price: vp.price,
          discount_price: vp.discount_price,
        }));

        const averageRating = await calculateRating(product.id);

        return {
          id: product.id,
          soldQuantity: product.soldQuantity || 0,
          imageUrl: product.imageUrl,
          discountPercent: product.discount_percent || 0,
          name: product.name_product,
          description: product.description,
          categoryId: product.category_id,
          averageRating: parseFloat(averageRating),
          variant_s_price:
            variants.length > 0 ? variants[0].discount_price : null,
          isHidden: product.isHidden,
        };
      })
    );

    return callback(null, {
      success: true,
      message: "Lấy danh sách sản phẩm theo danh mục thành công",
      data: result,
    });
  } catch (error) {
    console.error("Error in getProductByCategorys:", error);
    return callback(error);
  }
};

// -------------------- ---- Get Product Details ------------------------- //
const getProductDetailById = async (product_id, callback) => {
  try {
    const pro = await db.product.findOne({
      where: { id: product_id }, // Fixed to use the parameter instead of hardcoded value
      attributes: [
        "id",
        "name_product",
        "description",
        "soldQuantity",
        "stockQuantity",
        "imageUrl",
        "discount_percent",
        "category_id",
      ],
      include: [
        {
          model: db.variantProduct,
          as: "variantProducts",
          include: [
            {
              model: db.variant,
              as: "variant",
              include: [
                {
                  model: db.order_line,
                  as: "orderLines",
                  required: false,
                  attributes: ["id", "variant_id", "product_id"],
                  where: { product_id: product_id }, // Chỉ lấy order_line của sản phẩm hiện tại
                  include: [
                    {
                      required: false,
                      model: db.review,
                      as: "review",
                      attributes: ["rating_star", "comment", "review_date"],
                    },
                  ],
                },
              ],
            },
          ],
        },
      ],
    });

    if (!pro) {
      console.log("Không tìm thấy sản phẩm");
      return callback(null, {
        message: "Khong tim thay san pham",
      });
    }

    // Thêm bước debug chi tiết
    console.log(`Tìm thấy sản phẩm: ${pro.name_product}`);

    // Log chi tiết các reviews trước khi tính trung bình
    let allReviews = [];
    pro.variantProducts.forEach((vp, vpIndex) => {
      console.log(
        `Kiểm tra variantProduct #${vpIndex + 1}, variant_id: ${vp.variant_id}`
      );

      if (vp.variant && vp.variant.orderLines) {
        vp.variant.orderLines.forEach((ol, olIndex) => {
          console.log(`  OrderLine #${olIndex + 1}, ID: ${ol.id}`);

          if (ol.review) {
            console.log(
              `    Review found: ID=${ol.review.id}, Rating=${ol.review.rating_star}`
            );
            if (ol.review.rating_star !== null) {
              allReviews.push(ol.review);
            }
          } else {
            console.log(`    Không có review cho order_line này`);
          }
        });
      } else {
        console.log(`  Không có orderLines cho variant này`);
      }
    });

    console.log(`Tổng số reviews hợp lệ: ${allReviews.length}`);

    // Kiểm tra và in từng đánh giá
    if (allReviews.length > 0) {
      allReviews.forEach((r, index) => {
        console.log(`Review #${index + 1}: rating_star = ${r.rating_star}`);
      });
    }

    // Tính trung bình rating
    const averageRating =
      allReviews.length > 0
        ? (
            allReviews.reduce((sum, r) => sum + r.rating_star, 0) /
            allReviews.length
          ).toFixed(2)
        : 0; // Trả về 0 thay vì null nếu không có đánh giá

    const result = {
      ...pro.toJSON(),
      averageRating: parseFloat(averageRating), // Chuyển đổi averageRating thành số
    };

    console.log("Loại của result:", typeof result);
    console.log(JSON.stringify(result, null, 2));

    const productName = pro.name_product;
    console.log("Tên sản phẩm:", productName);

    // Chuẩn hóa thông tin variant
    let variants = [];
    pro.variantProducts.forEach((item) => {
      const id = item.variant_id;
      const name_variant = item.variant?.variant_name || "Unknown";
      const price = item.price;
      const discount_price = item.discount_price;
      variants.push({
        id: id,
        name_variant: name_variant,
        price: price,
        discount_price: discount_price,
      });
    });

    console.log("Variants:", variants);

    // Tạo đối tượng product_detail hoàn chỉnh
    const product_detail = {
      id: pro.id,
      name: pro.name_product,
      description: pro.description,
      soldQuantity: pro.soldQuantity || 0,
      stockQuantity: pro.stockQuantity || 0,
      imageUrl: pro.imageUrl,
      discount_percent: pro.discount_percent,
      category_id: pro.category_id,
      rating_star: parseFloat(averageRating), // Đảm bảo rating_star là số thay vì chuỗi
      variants: variants,
    };

    console.log(JSON.stringify(product_detail, null, 2));
    return callback(null, {
      success: true,
      message: "Get detail Product Succesfully",
      data: product_detail,
    });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết sản phẩm:", error);
    return callback(error);
  }
};

const calculateRating = async (product_id) => {
  const pro = await db.product.findOne({
    where: { id: product_id }, // Fixed to use the parameter instead of hardcoded value
    attributes: [
      "id",
      "name_product",
      "description",
      "soldQuantity",
      "stockQuantity",
      "imageUrl",
      "discount_percent",
      "category_id",
    ],
    include: [
      {
        model: db.variantProduct,
        as: "variantProducts",
        include: [
          {
            model: db.variant,
            as: "variant",
            include: [
              {
                model: db.order_line,
                as: "orderLines",
                required: false,
                attributes: ["id", "variant_id", "product_id"],
                where: { product_id: product_id }, // Chỉ lấy order_line của sản phẩm hiện tại
                include: [
                  {
                    required: false,
                    model: db.review,
                    as: "review",
                    attributes: ["rating_star", "comment", "review_date"],
                  },
                ],
              },
            ],
          },
        ],
      },
    ],
  });

  // Log chi tiết các reviews trước khi tính trung bình
  let allReviews = [];
  pro.variantProducts.forEach((vp, vpIndex) => {
    console.log(
      `Kiểm tra variantProduct #${vpIndex + 1}, variant_id: ${vp.variant_id}`
    );

    if (vp.variant && vp.variant.orderLines) {
      vp.variant.orderLines.forEach((ol, olIndex) => {
        console.log(`  OrderLine #${olIndex + 1}, ID: ${ol.id}`);

        if (ol.review) {
          console.log(
            `    Review found: ID=${ol.review.id}, Rating=${ol.review.rating_star}`
          );
          if (ol.review.rating_star !== null) {
            allReviews.push(ol.review);
          }
        } else {
          console.log(`    Không có review cho order_line này`);
        }
      });
    } else {
      console.log(`  Không có orderLines cho variant này`);
    }
  });

  // Kiểm tra và in từng đánh giá
  if (allReviews.length > 0) {
    allReviews.forEach((r, index) => {
      console.log(`Review #${index + 1}: rating_star = ${r.rating_star}`);
    });
  }

  // Tính trung bình rating
  const averageRating =
    allReviews.length > 0
      ? (
          allReviews.reduce((sum, r) => sum + r.rating_star, 0) /
          allReviews.length
        ).toFixed(2)
      : 0; // Trả về 0 thay vì null nếu không có đánh giá
  return averageRating;
};

const searchProduct = async (
  { query, category, variant, minPrice, maxPrice, sort, page = 1, limit = 10 },
  callback
) => {
  try {
    page = Math.max(1, parseInt(page));
    limit = Math.max(1, parseInt(limit));
    const offset = (page - 1) * limit;

    console.log("▶️ INPUT:", {
      query,
      category,
      variant,
      minPrice,
      maxPrice,
      sort,
      page,
      limit,
    });

    const productWhere = { isHidden: false };
    const variantProductWhere = {};
    const variantWhere = {};

    if (query) {
      const safeQuery = query.replace(/'/g, "");
      productWhere.name_product = { [Op.iLike]: `%${safeQuery}%` };
    }

    if (category) {
      productWhere["$category.category_name$"] = category;
    }

    if (variant) {
      variantWhere.variant_name = variant; // Ví dụ: L
    }

    if (minPrice || maxPrice) {
      variantProductWhere.discount_price = {};
      if (minPrice)
        variantProductWhere.discount_price[Op.gte] = parseFloat(minPrice);
      if (maxPrice)
        variantProductWhere.discount_price[Op.lte] = parseFloat(maxPrice); // Ví dụ: <= 40000
    }

    // Xử lý sắp xếp
    let order = [["name_product", "DESC"]];
    if (sort === "price_asc") {
      order = [
        [
          { model: db.variantProduct, as: "variantProducts" },
          "discount_price",
          "ASC",
        ],
      ];
    } else if (sort === "price_desc") {
      order = [
        [
          { model: db.variantProduct, as: "variantProducts" },
          "discount_price",
          "DESC",
        ],
      ];
    } else if (sort === "popular") {
      order = [["soldQuantity", "DESC"]];
    } else if (sort === "rating") {
      order = []; // Không sắp xếp trong SQL, sẽ sắp xếp sau
    }

    console.log("🔧 Sequelize where:", {
      productWhere,
      variantProductWhere,
      variantWhere,
      order,
    });

    const { rows, count } = await db.product.findAndCountAll({
      where: productWhere,
      include: [
        {
          model: db.category,
          as: "category",
          attributes: ["category_name"],
          required: false,
        },
        {
          model: db.variantProduct,
          as: "variantProducts",
          required: true,
          where:
            Object.keys(variantProductWhere).length > 0
              ? variantProductWhere
              : undefined,
          attributes: ["id", "variant_id", "price", "discount_price"],
          include: [
            {
              model: db.variant,
              as: "variant",
              where:
                Object.keys(variantWhere).length > 0 ? variantWhere : undefined,
              attributes: ["id", "variant_name"],
              required: true,
            },
          ],
        },
      ],
      subQuery: false,
      order,
      offset,
      limit,
      distinct: true,
      raw: false,
      nest: true,
    });

    console.log(`Tổng sản phẩm từ DB: ${count}`);

    const result = await Promise.all(
      rows.map(async (product, index) => {
        const variants = product.variantProducts.map((vp) => ({
          id: vp.variant_id,
          name_variant: vp.variant?.variant_name || null,
          price: vp.price,
          discount_price: vp.discount_price,
        }));

        // Kiểm tra nếu có variant được chỉ định (ví dụ: L)
        if (variant) {
          const matchedVariant = variants.find(
            (v) => v.name_variant === variant
          );
          if (!matchedVariant) {
            console.log(
              `Bỏ: ${product.name_product} - không có biến thể ${variant}`
            );
            return null;
          }
        }

        // Truy vấn bổ sung để lấy discount_price của variant S
        const variantS = await db.variantProduct.findOne({
          where: {
            product_id: product.id,
          },
          include: [
            {
              model: db.variant,
              as: "variant",
              where: { variant_name: "S" },
              attributes: ["variant_name"],
            },
          ],
          attributes: ["discount_price"],
          raw: true,
        });

        const priceS = variantS ? variantS.discount_price : null;

        const avgRating = await calculateRating(product.id).catch(() => 0);

        console.log(`[${index}] ${product.name_product}`);
        variants.forEach((v) =>
          console.log(
            `   - Variant: ${v.name_variant} | Price: ${v.discount_price}`
          )
        );
        console.log(`   - Price_S: ${priceS}`);
        console.log(`   - AverageRating: ${avgRating}`);

        return {
          id: product.id,
          name: product.name_product,
          description: product.description || "",
          imageUrl: product.imageUrl || "",
          soldQuantity: product.soldQuantity || 0,
          discount_percent: product.discount_percent || 0,
          category_id: product.category_id,
          averageRating: parseFloat(avgRating) || 0,
          variant_s_price: priceS, // Giá của variant S
          isHidden: product.isHidden,
          // variants,
        };
      })
    );

    // Lọc bỏ các sản phẩm null và sắp xếp theo averageRating nếu sort === "rating"
    let filteredResult = result.filter((r) => r !== null);
    if (sort === "rating") {
      filteredResult.sort((a, b) => b.averageRating - a.averageRating);
    }

    const response = {
      data: filteredResult,
      message:
        filteredResult.length === 0
          ? "No products found matching your query."
          : undefined,
      pagination: {
        total: filteredResult.length,
        page,
        limit,
        hasNext: offset + filteredResult.length < count,
      },
    };

    console.log(
      `📦 Trả về ${filteredResult.length} sản phẩm cho trang ${page}`
    );

    if (callback) callback(null, response);
    return response;
  } catch (error) {
    console.error("❌ Error in searchProduct:", error);
    const errorResponse = {
      data: [],
      message: "An error occurred while searching for products.",
      pagination: { total: 0, page: 1, limit, hasNext: false },
    };
    if (callback) callback(error, errorResponse);
    return errorResponse;
  }
};
module.exports = {
  getAllProducts,
  updateProduct,
  deteleProduct,
  addProduct,
  getProductByCategorys,
  getProductByCategory,
  searchProduct,
  getProductDetailById,
  calculateRating,
};
