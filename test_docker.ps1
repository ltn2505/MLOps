# Script kiểm tra Docker Image trên Docker Desktop
Write-Host "=== Kiểm tra Docker Image trên Docker Desktop ===" -ForegroundColor Green
Write-Host ""

# Kiểm tra Docker đang chạy
Write-Host "1. Kiểm tra Docker..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "   ✓ Docker đang chạy" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Docker chưa chạy. Vui lòng mở Docker Desktop!" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Kiểm tra image đã pull chưa
Write-Host "2. Kiểm tra image đã pull chưa..." -ForegroundColor Yellow
$imageExists = docker images ghcr.io/ltn2505/mlops:latest --format "{{.Repository}}:{{.Tag}}" 2>$null
if ($imageExists) {
    Write-Host "   ✓ Image đã có: ghcr.io/ltn2505/mlops:latest" -ForegroundColor Green
    docker images ghcr.io/ltn2505/mlops:latest
} else {
    Write-Host "   ⚠ Image chưa có. Đang pull..." -ForegroundColor Yellow
    Write-Host "   Lưu ý: Nếu được yêu cầu đăng nhập, dùng:" -ForegroundColor Cyan
    Write-Host "   docker login ghcr.io -u ltn2505" -ForegroundColor Cyan
    Write-Host ""
    docker pull ghcr.io/ltn2505/mlops:latest
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Pull thành công!" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Pull thất bại. Kiểm tra đăng nhập GitHub Container Registry" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# Kiểm tra container đang chạy
Write-Host "3. Kiểm tra container..." -ForegroundColor Yellow
$containerRunning = docker ps --filter "name=mlops-app" --format "{{.Names}}" 2>$null
if ($containerRunning) {
    Write-Host "   ✓ Container đang chạy: mlops-app" -ForegroundColor Green
    docker ps --filter "name=mlops-app"
} else {
    Write-Host "   ⚠ Container chưa chạy. Đang khởi động..." -ForegroundColor Yellow
    docker run -d -p 5000:5000 --name mlops-app ghcr.io/ltn2505/mlops:latest
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Container đã khởi động!" -ForegroundColor Green
        Start-Sleep -Seconds 3
    } else {
        Write-Host "   ✗ Không thể khởi động container" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# Kiểm tra health
Write-Host "4. Kiểm tra health endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri http://localhost:5000/health -Method GET -TimeoutSec 5
    Write-Host "   ✓ Health check thành công!" -ForegroundColor Green
    Write-Host "   Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "   Model loaded: $($response.model_loaded)" -ForegroundColor Cyan
} catch {
    Write-Host "   ⚠ Health check thất bại. Container có thể đang khởi động..." -ForegroundColor Yellow
    Write-Host "   Đợi thêm vài giây rồi thử lại" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Hoàn tất! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Truy cập ứng dụng tại: http://localhost:5000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Các lệnh hữu ích:" -ForegroundColor Yellow
Write-Host "  - Xem logs: docker logs mlops-app" -ForegroundColor White
Write-Host "  - Dừng container: docker stop mlops-app" -ForegroundColor White
Write-Host "  - Xóa container: docker rm mlops-app" -ForegroundColor White
Write-Host "  - Xem trong Docker Desktop: Mở Docker Desktop > Containers" -ForegroundColor White

