# News App Flutter

Ứng dụng quản lý tin tức cá nhân được xây dựng bằng Flutter theo yêu cầu bài thi thực hành giữa kỳ môn Chuyên đề tốt nghiệp 2.

## Thông tin đề tài

Chủ đề: Xây dựng ứng dụng quản lý tin tức cá nhân (News App)

## 👨‍🎓 Thông tin sinh viên

* Họ tên: **Nguyễn Trí Dũng**
* Mã sinh viên: **20223155**
* Số điện thoại: **0378519357**

## Chức năng chính

- Đăng ký tài khoản
- Đăng nhập tài khoản
- Hiển thị danh sách tin tức từ API
- Hiển thị ảnh, tiêu đề, mô tả và ngày đăng
- Tìm kiếm bài viết theo tiêu đề
- Xem chi tiết bài viết
- Thêm hoặc xóa bài viết yêu thích
- Lưu danh sách yêu thích riêng theo từng tài khoản
- Pull to refresh để cập nhật dữ liệu
- Xử lý lỗi API và mất kết nối
- Hiển thị loading khi đang tải dữ liệu

## Công nghệ sử dụng

- Flutter
- Dart
- Provider
- HTTP
- SharedPreferences

## Kiến trúc project

Project được tổ chức theo hướng tách lớp rõ ràng:

- `models`: chứa model dữ liệu
- `services`: xử lý gọi API và lưu local
- `repositories`: trung gian lấy dữ liệu
- `providers`: quản lý trạng thái
- `screens`: giao diện màn hình
- `widgets`: các widget tái sử dụng
- `core`: exception, utils, helper

## Cấu trúc thư mục

```text
lib/
├── core/
│   ├── exceptions/
│   ├── services/
│   └── utils/
├── models/
├── providers/
├── repositories/
├── screens/
│   ├── auth/
├── services/
├── widgets/
└── main.dart
