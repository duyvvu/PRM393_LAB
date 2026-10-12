# LAB 8: Building an API-powered List Screen (Flutter + REST API)

## 📌 Giới thiệu & Mục tiêu
Bài thực hành Lab 08 xây dựng ứng dụng Flutter hoàn chỉnh kết nối REST API công khai (`https://jsonplaceholder.typicode.com/posts`), áp dụng mô hình Service Layer, xử lý chuyển đổi JSON sang Model, quản lý trạng thái bất đồng bộ với `FutureBuilder`, và hỗ trợ thêm mới dữ liệu bằng `POST`.

## 📁 Cấu trúc thư mục mã nguồn
```text
lab8_networking/
├── lib/
│   ├── models/
│   │   └── post.dart                 # Model Post (fromJson, toJson)
│   ├── services/
│   │   └── api_service.dart          # Service Layer (GET & POST qua http)
│   ├── screens/
│   │   ├── post_list_screen.dart     # Màn hình danh sách (FutureBuilder, RefreshIndicator, Retry)
│   │   ├── post_detail_screen.dart   # Màn hình chi tiết bài viết (Bonus)
│   │   └── create_post_screen.dart   # Màn hình tạo mới bài viết (Form POST)
│   ├── main.dart                     # Entry point chính của ứng dụng
│   └── main_dartpad.dart             # Phiên bản gộp toàn bộ trong 1 file (dùng cho DartPad)
└── test/
    └── widget_test.dart              # Unit test & Widget smoke test
```

---

## 🚀 Các tính năng đã hoàn thiện

### 1. Lab 8.1 - Simple GET Request
- Sử dụng thư viện `http` kết nối tới `https://jsonplaceholder.typicode.com/posts`.
- Kiểm tra mã phản hồi HTTP (`statusCode == 200`).
- Bắt lỗi mạng (`SocketException`, `TimeoutException`, `FormatException`).

### 2. Lab 8.2 - JSON → Model Conversion & ListView
- Tạo class model [`Post`](lib/models/post.dart) với `factory Post.fromJson(Map<String, dynamic> json)` và `toJson()`.
- Chuyển mảng raw JSON thành `List<Post>`.
- Hiển thị danh sách bằng `ListView.builder` với Material 3 `Card` & `ListTile` đẹp mắt (hiển thị ID badge, Title, Body tóm tắt).

### 3. Lab 8.3 - Loading & Error Handling
- Áp dụng `FutureBuilder<List<Post>>` quản lý trọn vẹn 3 trạng thái:
  - **Loading State:** `CircularProgressIndicator` kèm thông điệp thân thiện.
  - **Error State:** Icon cảnh báo, thông báo lỗi trực quan và nút **"Retry"** để tải lại.
  - **Success State:** Hiển thị danh sách `ListView.builder`.

### 4. Lab 8.4 - Service Layer Pattern
- Tách biệt logic gọi mạng vào class [`ApiService`](lib/services/api_service.dart).
- Hỗ trợ Dependency Injection (`http.Client`) giúp code chuẩn kiến trúc và dễ dàng viết test.

### 5. Bonus Enhancements
- **Pull-to-refresh:** Tích hợp `RefreshIndicator` kéo xuống để làm mới danh sách.
- **Detail Screen:** Chạm vào từng bài viết để mở [`PostDetailScreen`](lib/screens/post_detail_screen.dart) xem đầy đủ thông tin.
- **POST Request:** Nút FloatingActionButton mở form [`CreatePostScreen`](lib/screens/create_post_screen.dart) cho phép tạo mới bài viết gửi qua `http.post` và hiển thị phản hồi thành công.

---

## 🛠 Hướng dẫn chạy ứng dụng

### Chạy trên máy tính (VS Code / Android Studio / Terminal):
1. Chuyển vào thư mục dự án:
   ```bash
   cd lab8_networking
   ```
2. Cài đặt dependencies (nếu cần):
   ```bash
   flutter pub get
   ```
3. Chạy kiểm thử:
   ```bash
   flutter test
   flutter analyze
   ```
4. Khởi chạy ứng dụng:
   ```bash
   flutter run -d chrome
   # hoặc
   flutter run -d windows
   ```

### Chạy trên DartPad:
Nếu nộp bài bằng link DartPad hoặc chạy trực tiếp trên trình duyệt không cần cài đặt:
1. Truy cập [DartPad Flutter](https://dartpad.dev/flutter)
2. Mở file [`lib/main_dartpad.dart`](lib/main_dartpad.dart), sao chép toàn bộ nội dung và dán vào DartPad.
3. Nhấn **Run** để trải nghiệm.
