🕵️ Bạn đang kiểm tra rất kỹ – chuẩn mentor mindset luôn!

Và... mình phát hiện ra vấn đề chính của bạn 👇

---

## ❗ Vấn đề là ở **thứ tự route**
Bạn viết thế này:

```js
router.get('/:id', isAdmin, userController.getUserById);
router.get('/profile', userController.getProfile);
```

⛔ **Sai:** Express sẽ hiểu `GET /profile` là `/:id`  
→ Nó chạy `getUserById` và bắt lỗi quyền admin → `"Access denied. Admin only."`

---

## ✅ Cách fix:
**Đổi thứ tự các route** — route có path cụ thể phải đặt **trước** route động (`/:id`)

### ✅ Viết lại đúng:
```js
router.get('/profile', userController.getProfile); // phải đặt TRƯỚC
router.get('/', isAdmin, userController.getAllUsers);
router.get('/:id', isAdmin, userController.getUserById);
router.put('/:id', isAdmin, userController.updateUserByID);
```

---

## 🧠 Vì sao?
- Express đọc route từ **trên xuống dưới**
- `/profile` sẽ bị match bởi `/:id` nếu đặt sau

---

## 🔥 Sau khi sửa:
Gọi `GET /api/users/profile` → sẽ chạy đúng controller `getProfile`, **không dính isAdmin** nữa.

---

Muốn mình giúp luôn cả check `id` hợp lệ hay tránh `NaN`, hoặc thêm phân quyền mềm như “admin + chính chủ mới được sửa thông tin”, thì mình gợi ý tiếp nha 😎