# Hướng dẫn cấu hình Docker Hub cho CI/CD

## 🎯 Mục tiêu

Push Docker image lên **Docker Hub** để có thể pull và chạy trên bất kỳ máy nào có Docker.

## Bước 1: Tạo tài khoản Docker Hub

1. Truy cập: https://hub.docker.com/signup
2. Điền thông tin:
   - Username (ví dụ: `ltn2505`)
   - Email
   - Password
3. Xác nhận email
4. Đăng nhập: https://hub.docker.com/login

## Bước 2: Tạo Access Token (Personal Access Token)

### Cách 1: Tạo token mới (Khuyến nghị)

1. Đăng nhập Docker Hub
2. Click vào **username** (góc trên bên phải) → **Account Settings**
3. Vào **Security** → **New Access Token**
4. Điền thông tin:
   - **Description**: `GitHub Actions CI/CD`
   - **Access permissions**: Chọn **Read & Write** (hoặc **Read, Write & Delete**)
5. Click **Generate**
6. **Copy token ngay** (chỉ hiển thị 1 lần!)
   - Token có dạng: `dckr_pat_xxxxxxxxxxxxxxxxxxxx`

### Cách 2: Sử dụng password (không khuyến nghị)

- Docker Hub đã không còn hỗ trợ password trực tiếp
- Phải dùng Access Token

## Bước 3: Cấu hình GitHub Secrets

1. Truy cập repository: https://github.com/ltn2505/MLOps
2. Vào **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

### Thêm 2 secrets:

#### Secret 1: `DOCKER_HUB_USERNAME`
- **Name**: `DOCKER_HUB_USERNAME`
- **Value**: Username Docker Hub của bạn (ví dụ: `ltn2505`)
- Click **Add secret**

#### Secret 2: `DOCKER_HUB_TOKEN`
- **Name**: `DOCKER_HUB_TOKEN`
- **Value**: Access Token đã tạo ở bước 2
- Click **Add secret**

## Bước 4: Kiểm tra workflow

Sau khi thêm secrets:

1. Push code lên GitHub (hoặc đợi workflow tự chạy)
2. Vào tab **Actions** trong repository
3. Xem workflow "Build and Push Docker Image"
4. Kiểm tra các bước:
   - ✅ Log in to Docker Hub
   - ✅ Build and push Docker image
   - ✅ Image được push thành công

## Bước 5: Kiểm tra image trên Docker Hub

1. Truy cập: https://hub.docker.com/r/YOUR_USERNAME/mlops
   - Thay `YOUR_USERNAME` bằng username Docker Hub của bạn
2. Bạn sẽ thấy:
   - Image `mlops:latest`
   - Tags khác nhau
   - Thời gian push

## Bước 6: Pull và chạy image từ Docker Hub

### Trên bất kỳ máy nào có Docker:

```bash
# Pull image từ Docker Hub
docker pull YOUR_USERNAME/mlops:latest

# Chạy container
docker run -d -p 5000:5000 --name mlops-app YOUR_USERNAME/mlops:latest
```

**Ví dụ** (nếu username là `ltn2505`):
```bash
docker pull ltn2505/mlops:latest
docker run -d -p 5000:5000 --name mlops-app ltn2505/mlops:latest
```

## Lợi ích của Docker Hub

✅ **Public registry**: Ai cũng có thể pull (nếu public)  
✅ **Không cần đăng nhập**: Pull public images không cần token  
✅ **Phổ biến**: Docker Hub là registry phổ biến nhất  
✅ **Dễ sử dụng**: Chỉ cần `docker pull username/image:tag`  
✅ **Tích hợp tốt**: Hỗ trợ tốt với Docker Desktop và các công cụ khác

## So sánh Docker Hub vs GitHub Container Registry

| Tính năng | Docker Hub | GitHub Container Registry |
|-----------|------------|---------------------------|
| **Public access** | ✅ Dễ dàng | ⚠️ Cần đăng nhập |
| **Phổ biến** | ✅ Rất phổ biến | ⚠️ Ít phổ biến hơn |
| **Miễn phí** | ✅ Có giới hạn | ✅ Không giới hạn |
| **Tích hợp GitHub** | ⚠️ Cần config | ✅ Tích hợp sẵn |
| **Pull command** | `docker pull user/image` | `docker pull ghcr.io/user/repo` |

## Troubleshooting

### Lỗi: "unauthorized: authentication required"

**Nguyên nhân**: Token không đúng hoặc hết hạn

**Giải pháp**:
1. Tạo token mới trên Docker Hub
2. Cập nhật secret `DOCKER_HUB_TOKEN` trong GitHub

### Lỗi: "denied: requested access to the resource is denied"

**Nguyên nhân**: Username không đúng

**Giải pháp**:
1. Kiểm tra username Docker Hub
2. Cập nhật secret `DOCKER_HUB_USERNAME` trong GitHub

### Image không hiển thị trên Docker Hub

**Nguyên nhân**: Workflow chưa chạy hoặc lỗi

**Giải pháp**:
1. Kiểm tra tab **Actions** trong GitHub
2. Xem logs của workflow để tìm lỗi
3. Đảm bảo secrets đã được cấu hình đúng

## Cập nhật README

Sau khi setup xong, cập nhật README với thông tin pull từ Docker Hub:

```markdown
## 🐳 Docker

### Pull và chạy từ Docker Hub:

```bash
docker pull YOUR_USERNAME/mlops:latest
docker run -d -p 5000:5000 --name mlops-app YOUR_USERNAME/mlops:latest
```
```

## Tóm tắt

1. ✅ Tạo tài khoản Docker Hub
2. ✅ Tạo Access Token
3. ✅ Thêm secrets vào GitHub:
   - `DOCKER_HUB_USERNAME`
   - `DOCKER_HUB_TOKEN`
4. ✅ Push code → Workflow tự động build và push lên Docker Hub
5. ✅ Pull và chạy trên bất kỳ máy nào: `docker pull username/mlops:latest`

