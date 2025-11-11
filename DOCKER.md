# Hướng dẫn sử dụng Docker

## 🐳 Build Docker Image

### Build image local:
```bash
docker build -t mlops-app:latest .
```

### Chạy container:
```bash
docker run -d -p 5000:5000 --name mlops-app mlops-app:latest
```

### Hoặc sử dụng docker-compose:
```bash
docker-compose up -d
```

## 🚀 CI/CD với GitHub Actions

### Tự động build khi push lên main

Mỗi khi bạn push code lên nhánh `main`, GitHub Actions sẽ tự động:

1. ✅ Checkout code
2. ✅ Build Docker image
3. ✅ Push image lên GitHub Container Registry (ghcr.io)

### Xem Docker image đã build:

1. Truy cập: https://github.com/ltn2505/MLOps/pkgs/container/mlops
2. Hoặc pull image:
   ```bash
   docker pull ghcr.io/ltn2505/mlops:latest
   ```

### Sử dụng image từ registry:

```bash
# Pull image
docker pull ghcr.io/ltn2505/mlops:latest

# Chạy container
docker run -d -p 5000:5000 --name mlops-app ghcr.io/ltn2505/mlops:latest
```

## 📋 Các lệnh Docker hữu ích

### Xem logs:
```bash
docker logs mlops-app
docker logs -f mlops-app  # Follow logs
```

### Dừng container:
```bash
docker stop mlops-app
```

### Xóa container:
```bash
docker rm mlops-app
```

### Xem images:
```bash
docker images
```

### Xóa image:
```bash
docker rmi mlops-app:latest
```

### Vào trong container:
```bash
docker exec -it mlops-app bash
```

## 🔍 Kiểm tra health

```bash
curl http://localhost:5000/health
```

## 📝 Lưu ý

- Image được build tự động mỗi khi push lên `main`
- Image được lưu tại GitHub Container Registry
- Có thể pull và chạy image trên bất kỳ server nào có Docker
- Health check được cấu hình để đảm bảo container hoạt động tốt

