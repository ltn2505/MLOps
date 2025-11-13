# FAQ - Docker Hub Setup

## ❓ Có cần tạo repository trên Docker Hub trước không?

### ✅ Trả lời: **KHÔNG CẦN**

Docker Hub sẽ **tự động tạo repository** khi bạn push image lần đầu tiên.

## Cách hoạt động

### Khi push image lần đầu:

```bash
docker push YOUR_USERNAME/mlops:latest
```

Docker Hub sẽ:
1. ✅ Tự động tạo repository `mlops` dưới tài khoản của bạn
2. ✅ Upload image vào repository đó
3. ✅ Repository sẽ có URL: `https://hub.docker.com/r/YOUR_USERNAME/mlops`

### Repository được tạo tự động với:
- Tên: `mlops` (từ tên image)
- Owner: Username của bạn
- Visibility: Public (mặc định) hoặc Private (nếu bạn đã set)

## Tùy chọn: Tạo repository trước (Không bắt buộc)

Nếu bạn muốn tạo repository trước để:
- Đặt mô tả
- Chọn visibility (Public/Private)
- Thêm README
- Cấu hình settings

### Cách tạo repository trước:

1. Đăng nhập Docker Hub: https://hub.docker.com
2. Click **Repositories** → **Create Repository**
3. Điền thông tin:
   - **Name**: `mlops` (phải khớp với tên trong workflow)
   - **Visibility**: Public hoặc Private
   - **Description**: Mô tả repository
4. Click **Create**

### Lưu ý:

- Nếu tạo repository trước, **tên phải khớp** với tên trong workflow
- Trong workflow: `DOCKER_HUB_IMAGE: ${{ secrets.DOCKER_HUB_USERNAME }}/mlops`
- Repository name phải là: `mlops`

## So sánh

| Cách | Ưu điểm | Nhược điểm |
|------|---------|------------|
| **Tự động tạo** (Khuyến nghị) | ✅ Đơn giản, nhanh<br>✅ Không cần làm gì | ⚠️ Không thể set mô tả trước |
| **Tạo trước** | ✅ Có thể set mô tả, README<br>✅ Cấu hình settings trước | ⚠️ Phải làm thêm bước |

## Kết luận

**Khuyến nghị**: Không cần tạo repository trước. Chỉ cần:
1. ✅ Tạo tài khoản Docker Hub
2. ✅ Tạo Access Token
3. ✅ Thêm secrets vào GitHub
4. ✅ Push code → Repository sẽ được tạo tự động

Sau đó bạn có thể vào Docker Hub để chỉnh sửa mô tả, README, settings nếu cần.

