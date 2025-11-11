# Hướng dẫn kiểm tra Docker Image trên Docker Desktop

## Bước 1: Đảm bảo Docker Desktop đang chạy

1. Mở **Docker Desktop** trên Windows
2. Đợi Docker khởi động hoàn toàn (icon Docker ở system tray không còn loading)
3. Kiểm tra Docker đang chạy:
   ```powershell
   docker --version
   docker ps
   ```

## Bước 2: Pull Docker Image từ GitHub Container Registry

Sau khi GitHub Actions build xong (khoảng 2-5 phút), pull image:

```powershell
docker pull ghcr.io/ltn2505/mlops:latest
```

**Lưu ý**: Nếu được yêu cầu đăng nhập:
```powershell
# Đăng nhập vào GitHub Container Registry
echo $env:GITHUB_TOKEN | docker login ghcr.io -u ltn2505 --password-stdin
```

Hoặc đăng nhập thủ công:
```powershell
docker login ghcr.io
# Username: ltn2505
# Password: Personal Access Token (với quyền read:packages)
```

## Bước 3: Kiểm tra Image trong Docker Desktop

1. Mở **Docker Desktop**
2. Vào tab **Images** (bên trái)
3. Tìm image: `ghcr.io/ltn2505/mlops:latest`
4. Bạn sẽ thấy:
   - Image name và tag
   - Size của image
   - Thời gian tạo
   - Image ID

## Bước 4: Chạy Container từ Docker Desktop

### Cách 1: Sử dụng Docker Desktop GUI

1. Trong tab **Images**, tìm `ghcr.io/ltn2505/mlops:latest`
2. Click nút **Run** (hoặc click vào image)
3. Cấu hình:
   - **Container name**: `mlops-app` (tùy chọn)
   - **Ports**: 
     - Host: `5000`
     - Container: `5000`
   - Click **Run**

### Cách 2: Sử dụng Command Line

```powershell
# Chạy container
docker run -d -p 5000:5000 --name mlops-app ghcr.io/ltn2505/mlops:latest

# Hoặc với restart policy
docker run -d -p 5000:5000 --name mlops-app --restart unless-stopped ghcr.io/ltn2505/mlops:latest
```

## Bước 5: Kiểm tra Container đang chạy

### Trong Docker Desktop:

1. Vào tab **Containers** (bên trái)
2. Tìm container `mlops-app`
3. Kiểm tra:
   - Status: **Running** (màu xanh)
   - Port: `5000:5000`
   - CPU/Memory usage

### Hoặc dùng Command Line:

```powershell
# Xem danh sách containers
docker ps

# Xem logs
docker logs mlops-app

# Xem logs real-time
docker logs -f mlops-app
```

## Bước 6: Test ứng dụng

### 1. Kiểm tra Health Endpoint:

```powershell
# PowerShell
Invoke-WebRequest -Uri http://localhost:5000/health | Select-Object -ExpandProperty Content

# Hoặc dùng curl (nếu có)
curl http://localhost:5000/health
```

Kết quả mong đợi:
```json
{"model_loaded":true,"status":"healthy"}
```

### 2. Mở trình duyệt:

Truy cập: **http://localhost:5000**

Bạn sẽ thấy:
- Form nhập 10 features
- Nút "Dự đoán"
- Nút "Điền dữ liệu mẫu"

### 3. Test API:

```powershell
# Test predict API
$body = @{
    feature_0 = 1.125
    feature_1 = 1.178
    feature_2 = 0.494
    feature_3 = 0.791
    feature_4 = -0.614
    feature_5 = 1.347
    feature_6 = 1.420
    feature_7 = 1.357
    feature_8 = 0.966
    feature_9 = -1.981
} | ConvertTo-Json

Invoke-RestMethod -Uri http://localhost:5000/predict -Method POST -Body $body -ContentType "application/json"
```

## Bước 7: Xem Logs trong Docker Desktop

1. Vào tab **Containers**
2. Click vào container `mlops-app`
3. Vào tab **Logs** để xem:
   - Logs khởi động
   - Logs của Flask app
   - Lỗi (nếu có)

## Bước 8: Dừng và Xóa Container

### Trong Docker Desktop:

1. Vào tab **Containers**
2. Click vào container `mlops-app`
3. Click nút **Stop** để dừng
4. Click nút **Delete** để xóa

### Hoặc dùng Command Line:

```powershell
# Dừng container
docker stop mlops-app

# Xóa container
docker rm mlops-app

# Dừng và xóa cùng lúc
docker rm -f mlops-app
```

## Troubleshooting

### Container không start:

```powershell
# Xem logs để tìm lỗi
docker logs mlops-app

# Kiểm tra port đã được sử dụng chưa
netstat -ano | findstr :5000
```

### Port đã được sử dụng:

```powershell
# Chạy với port khác
docker run -d -p 5001:5000 --name mlops-app ghcr.io/ltn2505/mlops:latest
# Sau đó truy cập: http://localhost:5001
```

### Image không tìm thấy:

```powershell
# Kiểm tra image đã pull chưa
docker images | findstr mlops

# Pull lại nếu cần
docker pull ghcr.io/ltn2505/mlops:latest
```

### Lỗi đăng nhập GitHub Container Registry:

1. Tạo Personal Access Token:
   - GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Generate new token với quyền: `read:packages`
2. Đăng nhập:
   ```powershell
   docker login ghcr.io -u ltn2505
   # Password: Paste token
   ```

## Tóm tắt các lệnh thường dùng

```powershell
# Pull image
docker pull ghcr.io/ltn2505/mlops:latest

# Chạy container
docker run -d -p 5000:5000 --name mlops-app ghcr.io/ltn2505/mlops:latest

# Xem logs
docker logs mlops-app

# Dừng container
docker stop mlops-app

# Xóa container
docker rm mlops-app

# Xem danh sách images
docker images

# Xem danh sách containers
docker ps -a
```

