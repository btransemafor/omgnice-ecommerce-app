const { param } = require("../routes/auth.routes");
const productService = require("../services/product.services");
const productServiceAdmin = require("../services/admin/product.services");

// Get All Products
const getAllProducts = (request, response) => {
  // Goi getAllProduct tu Service layer
  productService.getAllProducts((err, result) => {
    if (err) {
      return response.status(500).json("Server Error");
    }

    if (!result.success) {
      return response
        .status(404)
        .json({ message: "Khong tim thay san pham nao!" });
    }

    return response.status(200).json(result);
  });
};

// Update San Pham
const updateProduct = (req, res) => {
  // Lay id tu tham so url req
  const id = req.params.id;
  const updateProductData = req.body;

  /////// CHÚ Ý LẠI CÁCH TRUYỀN
  productService.updateProduct(
    { id: id, updateProductData: updateProductData },
    (error, result) => {
      if (error) {
        return res.status(500).json({ message: error.message });
      }
      if (!result.success) {
        return res.status(404).json(result);
      }

      return res.status(200).json(result);
    }
  );
};

const updateProductNew = async (req, res) => {
  try {
    const productId = req.params.id;

    const body = req.body;
    const imageUrl = req.file ? req.file.path : null;

    console.log("📦 File received:", req.file);
    console.log("📩 Body received:", body);
    console.log(productId);

    // Chuẩn bị object để chỉ chứa các trường cần update
    const updateFields = {};

    // Chỉ thêm những trường nào thực sự tồn tại trong req.body
    if (body.name) updateFields.name_product = body.name;
    if (body.description) updateFields.description = body.description;
    if (body.category_id) updateFields.category_id = body.category_id;
    if (body.discount_percent)
      updateFields.discount_percent = body.discount_percent;
    if (body.soldQuantity)
      updateFields.soldQuantity = Number(body.soldQuantity);
    if (body.isHidden !== undefined) {
      updateFields.isHidden =
        body.isHidden === "true" || body.isHidden === true;
    }
    if (body.variants) updateFields.variants = body.variants;

    // Nếu có image
    if (imageUrl) updateFields.imageUrl = imageUrl;
    if (body.imageUrl) {
      // Nếu có trường imageUrl trong body, ưu tiên sử dụng n\
      console.log("BOdy", body.imageUrl);
      updateFields.imageUrl = body.imageUrl;
    }
    // Nếu có variants
    if (body.variants) {
      try {
        updateFields.variants =
          typeof body.variants === "string"
            ? JSON.parse(body.variants)
            : body.variants;
      } catch (err) {
        return res
          .status(400)
          .json({ message: 'Trường "variants" không hợp lệ (phải là JSON).' });
      }
    }

    // Gọi service
    productServiceAdmin.updateProduct(
      { id: productId, updateProductData: updateFields },
      (error, result) => {
        if (error) {
          return res.status(500).json({ message: error.message });
        }
        if (!result.success) {
          return res.status(404).json({
            message: "Không tìm thấy sản phẩm hoặc không thể cập nhật",
          });
        }

        return res.status(200).json(result);
      }
    );
  } catch (err) {
    console.error("❌ Lỗi khi cập nhật sản phẩm:", err);
    return res.status(500).json({ message: "Lỗi máy chủ nội bộ" });
  }
};

// ------------ Delete Product --------------------//

const deleteProduct = (request, response) => {
  // get tham so id tren url
  const id = request.params.id;
  productService.deteleProduct(id, (err, result) => {
    if (err) {
      return response.status(500).json({ message: err.message });
    }
    if (!result.success) {
      return response.status(404).json(result);
    }
    return response.status(200).json(result);
  });
};

// -------------------- Thêm một sản phẩm --------------------- //
const addProduct = async (req, res) => {
  const image = req.file.path; // Lấy URL của ảnh đã upload lên Cloudinary

  // Sau khi quan middlerware Multer
  // Them file vaof req. => req.file vs req.body
  // req.file ( chi xu li 1 anh ) + chua info cua anh do ///// neu nhiu anh ( upload.array // upload.single )

  console.log("File received:", req.file); // Kiểm tra file được gửi lên
  //  console.log(' Body received:', req.body); // Kiểm tra dữ liệu khác được gửi lên

  if (!req.file) {
    return res.status(400).json({ message: "No file uploaded." });
  }

  // Đọc dữ liệu từ `req.body` (Không cần JSON.parse)
  const productData = {
    name_product: req.body.name,
    description: req.body.description,
    isHidden: req.body.isHidden || false,
    category_id: req.body.category_id,
    discount_percent: req.body.discount_percent,
    // imageUrl: req.file.filename // Lưu tên file đã upload
    imageUrl: image,
    soldQuantity: req.body.soldQuantity || 0,
    stockQuantity: req.body.stockQuantity || 0,
  };

  const variants = req.body.variants;
  const infoProduct = { productData, variants };
  console.log(" Product data:", productData);
  console.log(`${variants}`);

  productServiceAdmin.createProduct(infoProduct, (error, result) => {
    // Dấu `=>` phải đặt ngay sau dấu đóng `)`.
    if (error) {
      return res.status(500).json({ message: error.message });
    } else if (!result.success) {
      return res.status(409).json({ message: "Sản phẩm đã tồn tại" });
    }

    return res.status(201).json(result);
  });
};

const getProductByCategory = (req, res) => {
  // Lay category_id tu URL
  const category_id = req.params.category_id;
  console.log(category_id);
  productService.getProductByCategory(category_id, (error, result) => {
    if (error) {
      return res.status(500).json({ message: error.message });
    }
    return res.status(200).json(result);
  });
};

const getProductDetailById = (req, res) => {
  //
  const id = req.params.id;
  console.log(id);
  productService.getProductDetailById(id, (error, result) => {
    if (error) {
      return res.status(500).json({ message: error.message });
    }
    return res.status(200).json(result);
  });
};

const searchProduct = (req, res) => {
  const param = {
    query: req.query.query, // Lấy từ khóa tìm kiếm từ query parameter
  };

  productService.searchProduct(param, (error, result) => {
    if (error) {
      return res.status(500).json({
        success: false,
        message: "Lỗi tìm kiếm sản phẩm.",
        error: error.message,
      });
    }
    return res.status(200).json(result);
  });
};

// ---------------- FETCH LIST PRODUCT ------------------------- //
// ----- new version ----
// Lúc này tìm được cách trình bày gọn hơn cho phần frontend nên viết lại cho oke hehe
const fetchListProduct = (req, res) => {
  productServiceAdmin.fetchListProduct((error, result) => {
    if (error) {
      return res.status(500).json({ message: error.message });
    }
    if (!result.success) {
      return res.status(404).json({ message: "Khong tim thay san pham nao!" });
    }

    return res.status(200).json(result);
  });
};

const searchProductController = async (req, res) => {
  // Log input parameters from query
  console.log("Received query parameters:", req.query);
  console.log("🔥 Controller HIT");
  console.log("🧾 Query:", req.query);

  // Validate and extract query parameters
  const query = req.query.query || undefined;
  const category = req.query.category || undefined;
  const variant = req.query.variant || undefined;
  const sort = req.query.sort || undefined;

  console.log(`-------============${variant}`);

  const page = Math.max(1, parseInt(req.query.page) || 1);
  const limit = Math.max(1, parseInt(req.query.limit) || 10);
  const minPrice = req.query.minPrice
    ? parseFloat(req.query.minPrice)
    : undefined;
  const maxPrice = req.query.maxPrice
    ? parseFloat(req.query.maxPrice)
    : undefined;

  // Ensure page and limit are valid numbers
  const parsedPage = Math.max(1, parseInt(page) || 1);
  const parsedLimit = Math.max(1, parseInt(limit) || 10);

  const parsedMinPrice = minPrice ? parseFloat(minPrice) : undefined;
  const parsedMaxPrice = maxPrice ? parseFloat(maxPrice) : undefined;

  // Call the searchProduct service

  productService.searchProduct(
    {
      query,
      category,
      variant,
      minPrice: parsedMinPrice,
      maxPrice: parsedMaxPrice,
      sort,
      page: parsedPage,
      limit: parsedLimit,
    },
    (error, result) => {
      if (error) {
        return res.status(500).json({ message: "Server Internal Error" });
      }
      return res.status(200).json(result);
    }
  );
};

module.exports = {
  getAllProducts,
  fetchListProduct,
  updateProduct,
  deleteProduct,
  addProduct,
  getProductByCategory,
  searchProduct,
  getProductDetailById,
  updateProductNew,
  searchProductController,
};
