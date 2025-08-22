
#  OMGNICE - Mobile App

Omgnice là một ứng dụng đặt nước uống.

---

##  **Mục lục**
1. [ Giới thiệu](#-giới-thiệu)
2. [ Tính năng chính](#-tính-năng-chính)
3. [ Công nghệ sử dụng](#-công-nghệ-sử-dụng)
4. [ Cấu trúc dự án](#-cấu-trúc-dự-án)
5. [ Cài đặt](#️-cài-đặt)
6. [ Chạy ứng dụng](#-chạy-ứng-dụng)
7. [ Ảnh chụp màn hình](#-ảnh-chụp-màn-hình)
8. [ Tác giả](#-tác-giả)

---

##  **Giới thiệu**


OMGNICE là một ứng dụng mobile hiện đại, giúp khách hàng dễ dàng khám phá và đặt hàng các loại đồ uống yêu thích. Từ những loại trà sữa phổ biến, cà phê thơm ngon, nước ép trái cây tươi mát, đến các loại thức uống sáng tạo đầy màu sắc, tất cả đều có trong Omgnice.

Ứng dụng mang đến trải nghiệm người dùng mượt mà, giao diện đẹp mắt, và khả năng đặt hàng chỉ với vài thao tác chạm. Với OMGNice, bạn có thể:

Xem menu phong phú được cập nhật liên tục.

Đặt hàng nhanh chóng và theo dõi đơn hàng mọi lúc mọi nơi.

Nhận ưu đãi hấp dẫn dành riêng cho người dùng thân thiết.

OMGNICE - Thưởng thức hương vị tuyệt vời trong lòng bàn tay. 

---

##  **Tính năng chính**

-  Đăng ký & Đăng nhập (Email, Số điện thoại, Google).
-  Xem danh sách món ăn theo danh mục.
-  Tìm kiếm sản phẩm.
-  Thêm vào giỏ hàng và quản lý giỏ hàng.
-  Thanh toán đơn hàng.
-  Quản lý tài khoản người dùng.
-  Lịch sử đơn hàng.
-  Đặt lại mật khẩu bằng OTP qua email.

...... còn tiếp ... 

---

##  **Công nghệ sử dụng**

### 📱 **Frontend (Mobile App)**
- **Flutter** (Dart) - Framework chính để xây dựng UI.
- **Provider** - Quản lý state.
- **Picasso** - Tải ảnh từ server.

### 🌐 **Backend (API Server)**
- **Node.js & Express** - Framework backend.
- **PostgreSQL** - Cơ sở dữ liệu.
- **JWT** - Quản lý xác thực.
- **Socket.IO** - Chat realtime. (Dự kiến )


## 📂 **Cấu trúc dự án**

```plaintext
lib/
├── core/                          
├── features/
│   ├── auth/                      
│   │   ├── data/                  
│   │   │   ├── repositories/      
│   │   │   └── providers/         
│   │   ├── domain/                
│   │   │   ├── models/            
│   │   │   ├── repositories/      
│   │   │   └── usecases/          
│   │   └── presentation/          
│   │       ├── screens/           
│   │       └── widgets/           
│   ├── product/                   
│   ├── cart/                      
│   ├── order/                     
│   └── ........                 
├── main.dart                      
└── app.dart                       
```

---

##  **Cài đặt**





## **Tác giả**
