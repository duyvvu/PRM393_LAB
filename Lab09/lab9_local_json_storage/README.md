# PRM393 - Lab 09: Working With Local JSON Storage (Flutter + File Persistence)

Dự án Flutter hoàn chỉnh cho môn học PRM393 - Lab 09, tích hợp toàn bộ 3 bài thực hành về đọc, ghi và quản lý dữ liệu JSON cục bộ với cơ chế lưu trữ bền vững (Local Persistence).

---

## 🎯 Mục tiêu & Nội dung chính

1. **Lab 9.1 - Read JSON From Assets (Local Embedded File)**:
   - Nạp file JSON tĩnh từ bundle `assets/data/courses.json` sử dụng `rootBundle.loadString()`.
   - Phân tích cú pháp chuỗi JSON thành danh sách model `List<Course>` bằng `dart:convert`.
   - Hiển thị danh sách khóa học phong phú với `ListView.builder`, kèm bộ lọc tìm kiếm theo mã môn học/tên/giảng viên và hộp thoại xem chi tiết.
   - Hỗ trợ xem trực tiếp chuỗi JSON thô (Raw JSON Viewer).

2. **Lab 9.2 - Save & Load JSON From Device Storage**:
   - Sử dụng package `path_provider` để truy xuất thư mục tài liệu cục bộ (`getApplicationDocumentsDirectory()`).
   - Đọc và ghi danh sách `NoteItem` vào file `local_notes.json`.
   - Lưu trữ bền vững dữ liệu qua các lần khởi động lại ứng dụng (Persistence test).
   - Giao diện thêm ghi chú (Title, Content, đánh dấu Important), xóa ghi chú, lưu thủ công và tải lại từ đĩa.

3. **Lab 9.3 - Local JSON CRUD Mini Database (Search + Edit + Delete + Auto-Save)**:
   - Sử dụng file `crud_database.json` làm cơ sở dữ liệu mini cục bộ (seed ban đầu từ `assets/data/initial_database.json`).
   - Cung cấp đầy đủ các thao tác CRUD:
     - **Create**: Thêm sản phẩm mới với ID tự tăng tự động (`generateNextId`).
     - **Read**: Hiển thị danh sách sản phẩm với thẻ trạng thái (In Stock, Low Stock, Out of Stock) và danh mục.
     - **Update**: Modal Bottom Sheet chỉnh sửa chi tiết sản phẩm và cập nhật trực tiếp.
     - **Delete**: Xóa sản phẩm với hộp thoại xác nhận (Confirm Dialog).
     - **Search & Filter**: Tìm kiếm theo từ khóa và lọc nhanh theo danh mục (Chips filter).
   - Tự động lưu (`Auto-save`) file JSON sau mỗi thao tác thêm, sửa, xóa.
   - Tính năng khôi phục dữ liệu mẫu gốc (`Reset Database`) và xuất JSON thô (`Raw JSON Preview`).

---

## 📂 Cấu trúc thư mục mã nguồn

```
lab9_local_json_storage/
├── assets/
│   └── data/
│       ├── courses.json              # Dữ liệu tĩnh cho Lab 9.1
│       └── initial_database.json     # Dữ liệu khởi tạo cho Lab 9.3
├── lib/
│   ├── models/
│   │   ├── course.dart               # Model Course (Lab 9.1)
│   │   ├── note_item.dart            # Model NoteItem (Lab 9.2)
│   │   └── product_item.dart         # Model ProductItem (Lab 9.3)
│   ├── screens/
│   │   ├── lab9_1_assets_screen.dart # Giao diện Lab 9.1
│   │   ├── lab9_2_storage_screen.dart# Giao diện Lab 9.2
│   │   └── lab9_3_crud_screen.dart   # Giao diện Lab 9.3
│   ├── services/
│   │   ├── asset_service.dart        # Service đọc assets bundle
│   │   ├── file_storage_service.dart # Service đọc/ghi file local_notes.json
│   │   └── crud_database_service.dart# Service mini-database CRUD
│   └── main.dart                     # Navigation Hub điều hướng qua NavigationBar
└── test/
    └── widget_test.dart              # Automated Widget smoke test
```

---

## 🚀 Hướng dẫn chạy dự án

1. **Cài đặt dependencies**:
   ```bash
   flutter pub get
   ```

2. **Kiểm tra phân tích code (Linting)**:
   ```bash
   flutter analyze
   ```

3. **Chạy kiểm thử tự động (Unit / Widget tests)**:
   ```bash
   flutter test
   ```

4. **Khởi chạy ứng dụng**:
   ```bash
   flutter run
   ```

---

## 📊 Tiêu chuẩn đánh giá đáp ứng (100%)

- **JSON Reading (25%)**: Đọc và parse dữ liệu JSON từ assets bundle chính xác.
- **JSON Writing (25%)**: Lưu và ghi file JSON trên thiết bị bằng `path_provider`.
- **Local Persistence (20%)**: Dữ liệu lưu trữ ổn định khi khởi động lại app.
- **CRUD Functionality (20%)**: Thêm, xem chi tiết, sửa, xóa với xác nhận, tìm kiếm và lọc.
- **UI/UX Quality (10%)**: Giao diện chuẩn Material 3, phản hồi trực quan, thông báo snackbar đầy đủ.
