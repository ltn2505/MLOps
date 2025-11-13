# Sửa lỗi "Error: Password required" trong GitHub Actions

## 🔴 Lỗi hiện tại

```
Error: Password required
```

Lỗi này xảy ra ở step "Log in to Docker Hub" vì secrets chưa được cấu hình đúng.

## ✅ Cách sửa

### Bước 1: Kiểm tra secrets đã được thêm chưa

1. Truy cập repository: https://github.com/ltn2505/MLOps
2. Vào **Settings** → **Secrets and variables** → **Actions**
3. Kiểm tra xem có 2 secrets sau không:
   - `DOCKER_HUB_USERNAME`
   - `DOCKER_HUB_TOKEN`

### Bước 2: Thêm secrets (nếu chưa có)

#### Secret 1: `DOCKER_HUB_USERNAME`

1. Click **New repository secret**
2. **Name**: `DOCKER_HUB_USERNAME`
3. **Secret**: Nhập username Docker Hub của bạn (ví dụ: `ltn2505`)
4. Click **Add secret**

#### Secret 2: `DOCKER_HUB_TOKEN`

1. Click **New repository secret**
2. **Name**: `DOCKER_HUB_TOKEN`
3. **Secret**: Nhập Access Token từ Docker Hub
   - Nếu chưa có token, xem hướng dẫn tạo token bên dưới
4. Click **Add secret**

### Bước 3: Tạo Access Token trên Docker Hub (nếu chưa có)

1. Đăng nhập Docker Hub: https://hub.docker.com
2. Click vào **username** (góc trên bên phải) → **Account Settings**
3. Vào **Security** → **New Access Token**
4. Điền thông tin:
   - **Description**: `GitHub Actions CI/CD`
   - **Access permissions**: Chọn **Read & Write**
5. Click **Generate**
6. **Copy token ngay** (chỉ hiển thị 1 lần!)
   - Token có dạng: `dckr_pat_xxxxxxxxxxxxxxxxxxxx`
7. Paste token vào secret `DOCKER_HUB_TOKEN` trong GitHub

### Bước 4: Kiểm tra secrets đã đúng chưa

Đảm bảo:
- ✅ `DOCKER_HUB_USERNAME` = Username Docker Hub của bạn (không có khoảng trắng, không có ký tự đặc biệt)
- ✅ `DOCKER_HUB_TOKEN` = Access Token từ Docker Hub (bắt đầu bằng `dckr_pat_`)

### Bước 5: Re-run workflow

Sau khi thêm/cập nhật secrets:

1. Vào tab **Actions** trong repository
2. Click vào workflow run bị lỗi
3. Click nút **Re-run all jobs** (hoặc **Re-run failed jobs**)
4. Workflow sẽ chạy lại với secrets mới

## 🔍 Kiểm tra chi tiết

### Kiểm tra secret names có đúng không

Trong file `.github/workflows/docker-build.yml`, secrets được sử dụng là:
- `${{ secrets.DOCKER_HUB_USERNAME }}`
- `${{ secrets.DOCKER_HUB_TOKEN }}`

Đảm bảo tên secrets trong GitHub **chính xác** (phân biệt chữ hoa/thường):
- ✅ `DOCKER_HUB_USERNAME` (đúng)
- ❌ `docker_hub_username` (sai - chữ thường)
- ❌ `DOCKER_HUB_USER` (sai - thiếu NAME)

### Kiểm tra token có hợp lệ không

Token Docker Hub phải:
- ✅ Bắt đầu bằng `dckr_pat_`
- ✅ Có quyền **Read & Write** hoặc **Read, Write & Delete**
- ✅ Chưa hết hạn (nếu đã set expiration)

### Kiểm tra username có đúng không

Username Docker Hub:
- ✅ Không có khoảng trắng
- ✅ Không có ký tự đặc biệt
- ✅ Phải là username thực tế trên Docker Hub

## 🧪 Test secrets

Sau khi thêm secrets, có thể test bằng cách:

1. Tạo một workflow test đơn giản (tùy chọn)
2. Hoặc đợi workflow chạy lại sau khi push code mới

## 📝 Checklist

Trước khi re-run workflow, đảm bảo:

- [ ] Đã tạo tài khoản Docker Hub
- [ ] Đã tạo Access Token trên Docker Hub
- [ ] Đã thêm secret `DOCKER_HUB_USERNAME` vào GitHub
- [ ] Đã thêm secret `DOCKER_HUB_TOKEN` vào GitHub
- [ ] Tên secrets chính xác (phân biệt chữ hoa/thường)
- [ ] Token có quyền Read & Write
- [ ] Username đúng (không có khoảng trắng)

## 🚀 Sau khi sửa

Sau khi thêm secrets đúng:

1. Re-run workflow
2. Workflow sẽ:
   - ✅ Log in to Docker Hub thành công
   - ✅ Build Docker image
   - ✅ Push image lên Docker Hub
   - ✅ Push image lên GitHub Container Registry

## 💡 Lưu ý

- Secrets chỉ hiển thị khi tạo, không thể xem lại
- Nếu quên token, phải tạo token mới
- Secrets được mã hóa và bảo mật trong GitHub
- Chỉ có quyền admin của repository mới thấy được secrets

