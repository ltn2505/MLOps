# Cách lấy Username Docker Hub

## 🔍 Username Docker Hub là gì?

Username Docker Hub là **tên đăng nhập** của bạn trên Docker Hub (không phải email).

## 📍 Cách 1: Xem trên trang profile Docker Hub

1. Đăng nhập Docker Hub: https://hub.docker.com/login
2. Sau khi đăng nhập, click vào **username** ở góc trên bên phải
3. Username sẽ hiển thị ở:
   - Góc trên bên phải (sau khi click vào avatar)
   - URL profile: `https://hub.docker.com/u/YOUR_USERNAME`
   - Trang profile của bạn

## 📍 Cách 2: Xem trong URL

1. Đăng nhập Docker Hub
2. Click vào avatar/username ở góc trên bên phải
3. Xem URL trong trình duyệt:
   ```
   https://hub.docker.com/u/YOUR_USERNAME
   ```
   → `YOUR_USERNAME` chính là username của bạn

## 📍 Cách 3: Xem trong Account Settings

1. Đăng nhập Docker Hub
2. Click vào **username** → **Account Settings**
3. Vào tab **General**
4. Username sẽ hiển thị ở phần **Username** hoặc **Profile**

## 📍 Cách 4: Kiểm tra email đăng ký

Nếu bạn quên username, có thể:
1. Vào trang đăng nhập: https://hub.docker.com/login
2. Click "Forgot username?"
3. Nhập email đã đăng ký
4. Docker Hub sẽ gửi username về email

## 📍 Cách 5: Xem khi tạo repository

1. Đăng nhập Docker Hub
2. Vào **Repositories** → **Create Repository**
3. Username sẽ hiển thị trong format: `YOUR_USERNAME/repository-name`

## ✅ Ví dụ

Nếu URL profile của bạn là:
```
https://hub.docker.com/u/ltn2505
```

Thì username là: **`ltn2505`**

## 🔍 Kiểm tra username có đúng không

Sau khi lấy username, kiểm tra:

1. Truy cập: `https://hub.docker.com/u/YOUR_USERNAME`
2. Nếu thấy profile của bạn → Username đúng ✅
3. Nếu báo lỗi 404 → Username sai ❌

## 📝 Lưu ý

- Username **không có khoảng trắng**
- Username **không có ký tự đặc biệt** (trừ dấu gạch dưới `_` và dấu gạch ngang `-`)
- Username **phân biệt chữ hoa/thường** (thường là chữ thường)
- Username **không thể thay đổi** sau khi tạo tài khoản

## 🎯 Sử dụng username trong GitHub Secrets

Khi thêm secret `DOCKER_HUB_USERNAME` vào GitHub:

1. Vào: https://github.com/ltn2505/MLOps/settings/secrets/actions
2. Click **New repository secret**
3. **Name**: `DOCKER_HUB_USERNAME`
4. **Secret**: Nhập username Docker Hub của bạn (ví dụ: `ltn2505`)
5. Click **Add secret**

## 💡 Mẹo

Nếu bạn chưa có tài khoản Docker Hub:
1. Đăng ký tại: https://hub.docker.com/signup
2. Chọn username khi đăng ký
3. Username này sẽ là username Docker Hub của bạn

