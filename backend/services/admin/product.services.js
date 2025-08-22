const { db } = require("../../models/index");
const asyncService = require("../sync.services");
const createProduct = async (param, callback) => {
  const { productData, variants: variantData } = param;
  productData.solaQuantity = 0;

  try {
    // Kiểm tra tên sản phẩm trùng
    const existingProduct = await db.product.findOne({
      where: { name_product: productData.name_product },
    });

    if (existingProduct) {
      return callback(null, {
        success: false,
        message: `Tên sản phẩm đã tồn tại (ID: ${existingProduct.id})`,
      });
    }

    // Tạo sản phẩm
    const newProduct = await db.product.create({
      ...productData,
      createdAt: new Date(),
      updateAt: new Date()
    });

    const productId = newProduct.id;

    console.log("Product ID:", productId);

    // Log dữ liệu variants đầu vào để debug
    console.log("Variants input:", variantData);
    console.log("Variants type:", typeof variantData);

    // Xử lý variants một cách an toàn
    let parsedVariants = {};

    if (!variantData) {
      console.log("No variant data provided");
    } else if (typeof variantData === "object" && !Array.isArray(variantData)) {
      // Đã là object
      parsedVariants = variantData;
      console.log("Variants already an object");
    } else if (typeof variantData === "string") {
      // Xử lý trường hợp chuỗi đặc biệt
      try {
        if (variantData.startsWith('{"') || variantData.startsWith("[")) {
          parsedVariants = JSON.parse(variantData);
          console.log("Parsed valid JSON format");
        } else {
          console.log("Processing special format");
          const content = variantData.trim().slice(1, -1);
          const pairs = content.split(",");

          pairs.forEach((pair) => {
            const [key, valueStr] = pair.split(":").map((s) => s.trim());
            if (key && valueStr) {
              const value = parseFloat(valueStr);
              if (!isNaN(value)) {
                parsedVariants[key] = value;
              }
            }
          });

          console.log("Manually parsed special format:", parsedVariants);
        }
      } catch (error) {
        console.error("Error handling variant string:", error);
      }
    } else {
      console.log("Unexpected variant data type");
    }

    console.log("Final processed variants:", parsedVariants);

    // Tạo các variant
    const variantIds = ["1", "2", "3"];
    if (Object.keys(parsedVariants).length > 0) {
      console.log("Creating variants with data:", parsedVariants);

      // Tạo và track từng variant riêng lẻ để debug
      for (const id of variantIds) {
        try {
          const price = parsedVariants[id] ?? 0;
          console.log(`Creating variant ${id} with price ${price}`);

          const createdVariant = await db.variantProduct.create({
            product_id: productId,
            variant_id: parseInt(id),
            price: price,
            discount_price: price, // Sử dụng cùng giá trị cho discount_price
          });

          console.log(`Successfully created variant ${id}:`, createdVariant.id);
        } catch (error) {
          console.error(`Error creating variant ${id}:`, error);
        }
      }
    } else {
      console.log("Creating variants with default values");
      for (const id of variantIds) {
        try {
          const createdVariant = await db.variantProduct.create({
            product_id: productId,
            variant_id: parseInt(id),
            price: 0,
            discount_price: 0,
          });
          console.log(
            `Successfully created default variant ${id}:`,
            createdVariant.id
          );
        } catch (error) {
          console.error(`Error creating default variant ${id}:`, error);
        }
      }
    }

    // Kiểm tra các variant đã tạo
    try {
      const createdVariants = await db.variantProduct.findAll({
        where: {
          product_id: productId,
        },
      });
      console.log(
        `Found ${createdVariants.length} variants for product ${productId}:`,
        createdVariants.map(
          (v) => `ID: ${v.id}, VariantID: ${v.variant_id}, Price: ${v.price}`
        )
      );
    } catch (error) {
      console.error("Error checking created variants:", error);
    }

     // Gọi sync ngay sau khi thêm
        await asyncService.syncProducts();

    return callback(null, {
      success: true,
      message: "Thêm sản phẩm thành công",
      data: newProduct,
    });
  } catch (error) {
    console.error("Error creating product:", error);
    return callback(error);
  }
};

// --------------------- Get Product ---------------------- //
const fetchListProduct = async (callback) => {
  try {
    const products = await db.product.findAll({
      include: [
        {
          model: db.variantProduct,
          as: "variantProducts",
          attributes: ["id", "variant_id", "price", "discount_price"],
        },
      ],
    });
    if (!products) {
      return callback(null, {
        success: false,
        message: "Khong Tim thay san pham nap",
      });
    }
    return callback(null, {
      success: true,
      message: "Lay danh sach san pham thanh cong",
      data: products,
    });
  } catch (error) {
    console.error("Error Fetching Product: ", error);
    return callback(error);
  }
};
const updateProduct = async ({ id, updateProductData }, callback) => {
  try {
    const fields = Object.keys(updateProductData);
    if (fields.length === 0) {
      return callback(null, {
        success: false,
        message: "Không có trường nào để cập nhật",
      });
    }

    if (updateProductData.variants) {
      const variantEntries = Object.entries(updateProductData.variants);

      await Promise.all(
        variantEntries.map(async ([variantId, discount_price]) => {
          const [affected] = await db.variantProduct.update(
            { discount_price },
            {
              where: {
                product_id: id,
                variant_id: parseInt(variantId),
              },
            }
          );

          console.log(
            `Updated variant_id=${variantId} (product_id=${id}), affected=${affected}`
          );
        })
      );

      delete updateProductData.variants;
    }

    const [affectedRows] = await db.product.update(updateProductData, {
      where: { id },
      returning: true,
    });

    if (affectedRows === 0) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy sản phẩm",
      });
    }

    const updatedProduct = await db.product.findOne({
      where: { id },
      include: [{ model: db.variantProduct, as: "variantProducts" }],
    });

    if (!updatedProduct) {
      return callback(null, {
        success: false,
        message: "Không tìm thấy sản phẩm sau khi cập nhật",
      });
    }

    return callback(null, {
      success: true,
      message: "Cập nhật sản phẩm thành công",
      data: updatedProduct,
    });
  } catch (err) {
    console.error("Lỗi khi cập nhật sản phẩm:", err);
    return callback(err);
  }
};

module.exports = {
  createProduct,
  fetchListProduct,
  updateProduct,
};
