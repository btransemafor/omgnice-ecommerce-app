Người dùng sẽ lưu những thông tin gì ? 

```
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20) UNIQUE NOT NULL,
  password TEXT NOT NULL,
  avatar TEXT,
  date_of_birth DATE,  --  Ngày sinh của khách hàng
  street_address TEXT,
  ward VARCHAR(255),
  district VARCHAR(255),
  province VARCHAR(255),
  points INT DEFAULT 0,
  role ENUM('admin', 'customer') DEFAULT 'customer',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

```


**Sản phẩm:**
```
2️⃣ Bảng products (Sản phẩm)
Lưu trữ thông tin về từng món nước uống.

product_id (PK) - ID sản phẩm

name - Tên sản phẩm

description - Mô tả sản phẩm

category - Danh mục (Cà phê, Trà sữa,...)

price - Giá sản phẩm

image_url - Ảnh minh họa

size_options - Các kích cỡ (S, M, L) (JSON nếu có nhiều lựa chọn)

customization - Tùy chỉnh mức đường, đá (JSON) - note

discount - Giảm giá %

minute - thời gian dự kiến làm xong thức uống đó 

sold_count - Tổng số lượng đã bán

rating - Điểm đánh giá trung bình

created_at - Ngày tạo

updated_at - Ngày cập nhật 

```

**Category** 
```
CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,  -- ID danh mục tự tăng
  name VARCHAR(255) UNIQUE NOT NULL,  -- Tên danh mục (Cà phê, Trà sữa...)
);
```

**Product:**

```
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,  -- Liên kết với bảng categories
  price DECIMAL(10,2) NOT NULL,
  image_url TEXT,
  size_options JSONB DEFAULT '[]',
  customization JSONB DEFAULT '{}',
  discount DECIMAL(5,2) DEFAULT 0,
  minute INT DEFAULT 5,
  sold_count INT DEFAULT 0,
  rating DECIMAL(3,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

```



