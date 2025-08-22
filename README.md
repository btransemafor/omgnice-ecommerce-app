# OMGNICE E-commerce App Beverage

Ứng dụng Bán Nước Uống Thương Mại Điện Tử **OMGNICE** là ứng dụng di động giúp người dùng dễ dàng mua nước uống online chỉ với vài thao tác. Ứng dụng được phát triển nhằm mang đến giải pháp tiện lợi, nhanh chóng, giao diện đẹp mắt và tiết kiệm thời gian cho cả cá nhân và doanh nghiệp.
---

## 🌐 Demo
🔗 [Xem Demo tại đây](https://drive.google.com/drive/folders/1Zij3l4-yOJ26DuHOO_blaBVp4LK1BBuf?usp=sharing)  

---

## 📖 Mục lục
- [Giới thiệu](#-giới-thiệu)
- [Tính năng](#-tính-năng)
- [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
- [Cài đặt](#-hướng-Dẫn-Cài-Đặt-Dự-Án)
- [Cấu trúc thư mục](#-cấu-trúc-thư-mục)
- [Tác giả](#-tác-giả)

---

## 📌 Giới thiệu
OMGNice E-commerce App giúp kết nối người bán và người mua thông qua một nền tảng mua sắm trực tuyến được triển khai với hai vai trò: 
 - Người bán 
 - Người mua

---

## ✨ Tính năng
- Người dùng với vai trò là admin ( hay người bán ) thì tất yếu sẽ có các chức năng cơ bản của một user thông thường. 
    - 🔐 **Authentication**: Đăng ký, đăng nhập, quên mật khẩu, thay đổi mật khẩu, ... 
    - 🛒 **Quản lý giỏ hàng**: Thêm, xoá, cập nhật sản phẩm
 (size, số lượng)... 
    - 💳 **Tích hợp Thanh toán**: payOS, quét mã QR. 
    - 📦 **Theo dõi đơn hàng**: Kiểm tra trạng thái đơn hàng, hủy đơn hàng với các điều kiện cụ thể ... 
    -   **Tìm kiếm, Lọc sản phẩm:** Tìm kiếm theo từ khóa, theo size, đánh giá, sắp xếp, ... 
    - **ChatBot AI hỗ trợ khách hàng:** Hỗ trợ nhiều loại câu hỏi ... 
    - **Voucher khuyến mãi**
    - **Gửi đóng góp, kiếu nại**
- Chức năng riêng dành cho người bán (admin): phê duyệt đơn hàng, 
    - 📊 **Dashboard** cho Admin quản lý sản phẩm với nhiều biểu đồ đẹp... 
    - **Quản lý user**: Cấp quyền cho user, block user, tăng quà cho user 
    - **Quản lý banner**: Thêm xóa sửa 

---

## 🛠 Công nghệ sử dụng

### Frontend: Flutter (Dart)
### Backend: Node.js, Express
### Database: Postgres, sequelize
### Authentication: JWT
### Firebase Google Sign In

---

## ⚙️ Cài đặt
### Yêu cầu
- Node.js >= 20.12.2
- Flutter >= 3.x
- Postgres


## 📱 Hướng Dẫn Cài Đặt Dự Án

### Cấu hình Database 
- database 
- port 
- host
- password

### 🚀 Backend (Node.js)

#### Cấu hình môi trường

1. **Vào thư mục backend:**
   ```bash
   cd backend
   ```

2. **Cài đặt dependencies:**
   ```bash
   npm install
   ```

3. **Cấu hình môi trường:**
   ```bash
   cp example.env .env
   ```

4. **Chỉnh sửa file `.env`** với thông tin phù hợp:
   ```env
   PORT=8081
   JWT_SECRET=your_jwt_secret_key
   ...
   ```

5. **Chạy server:**
   ```bash
   node server.js
   ```

6. **Kiểm tra server:** Mở trình duyệt và truy cập `http://localhost:̀8081`

---

### 📱 Frontend (Flutter)

#### Cấu hình môi trường

1. **Vào thư mục frontend:**
   ```bash
   cd frontend
   ```

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Cấu hình API endpoint:**
   
   Mở file `lib/core/network/dio_client.dart` (hoặc file cấu hình network tương tự):
   
   ```dart

     // Cho emulator/simulator
     static const String baseUrl = 'http://localhost:5000';
     
     // Cho thiết bị thật - thay YOUR_IP bằng IP máy tính của bạn
     // static const String baseUrl = 'http://YOUR_IP:5000';
   
   ```

4. **Tìm IP máy tính (nếu test trên thiết bị thật):**
   
   **Windows:**
   ```bash
   ipconfig
   ```
   
   Tìm địa chỉ IP dạng `192.168.x.x` hoặc `10.x.x.x`

5. **Chạy ứng dụng Flutter:**
   ```bash
   # Kiểm tra thiết bị có sẵn
   flutter devices
   
   # Chạy trên emulator/simulator
   flutter run
   
   # Chạy trên thiết bị cụ thể
   flutter run -d <device_id>
   ```

---

## 🔧 Lưu Ý Quan Trọng

### Cho thiết bị thật (Physical Device):
- Đảm bảo máy tính và điện thoại cùng mạng WiFi
- Sử dụng IP nội bộ (LAN IP) thay vì `localhost`
- Kiểm tra firewall không block port

### Debug:
```bash
flutter run --verbose
```

## 📂 Cấu trúc Thư Mục

###  Cấu trúc Frontend (Flutter - Clean Architecture)

```
lib/
│── core/                         # Core config (router, network, constants, utils...)
│   ├── app_router.dart
│   ├── dio_client.dart
│   ├── errors/
│   ├── theme/
│   └── utils/
│
│── features/                     # Mỗi feature là 1 module độc lập
│   ├── auth/                     # Authentication Feature
│   │   ├── data/                 # Tầng Data: làm việc với API/DB
│   │   │   ├── models/           # Data Models (DTO)
│   │   │   ├── repositories/     # Implement repository
│   │   │   └── sources/          # API sources, local storage...
│   │   │
│   │   ├── domain/               # Tầng Domain: business logic
│   │   │   ├── entities/         # Entities (đối tượng thuần túy)
│   │   │   ├── repositories/     # Abstraction của repository
│   │   │   └── usecases/         # Business rules (LoginUseCase, RegisterUseCase...)
│   │   │
│   │   ├── presentation/         # Tầng UI
│   │   │   ├── pages/            # Screens/Pages (LoginPage, RegisterPage...)
│   │   │   ├── provider/         # State management (Provider/Bloc/Riverpod)
│   │   │   └── widgets/          # UI components nhỏ (form, button, input...)
│   │   │
│   │   └── auth_export.dart      # Export public API của feature
│   │
│   ├── product/                  # Feature quản lý sản phẩm
│   ├── cart/                     # Feature giỏ hàng
│   ├── order/                    # Feature đơn hàng
│   └── ...
│
└── main.dart                     # Entry point
```

###  Cấu trúc Backend (Nodejs)

```bash
backend/                    # Code server (Node.js + Express + Sequelize)
│── config/                 # Cấu hình (kết nối DB, dotenv, logger)
│── controllers/            # Xử lý request, gọi service, trả response
│── models/                 # Sequelize models (User, Product, Order, ...)
│── routes/                 # Định nghĩa API endpoints
│── middlewares/            # Middleware (auth, validate, error handling)
│── services/               # Business logic, thao tác với model qua repository
│── utils/                  # Helper functions (JWT, email, upload, ...)
│── migrations/             # Sequelize migrations
│── seeders/                # Dữ liệu mẫu (fake data)
│── server.js               # File khởi động server
│── .env                    # Biến môi trường
│── example.env             # File mẫu cho biến môi trường
│── package.json
```

## Tác Giả 👩‍💻

**Họ Tên:** Vo Ngoc Bao Tran  
**Email:** vongocbaotran754@gmail.com   
**Github:** [github.com/btransemafor](https://github.com/btransemafor/)   
**LinkedIn:** [linkedin.com/in/tranvo](https://www.linkedin.com/in/tran-vo-79923b266/) 

Nếu bạn có thắc mắc hoặc muốn đóng góp cho dự án, hãy liên hệ với mình nhé!
