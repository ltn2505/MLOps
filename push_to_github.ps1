# Script để push code lên GitHub
# Chạy script này sau khi đã tạo repository trên GitHub

Write-Host "=== Push code lên GitHub ===" -ForegroundColor Green
Write-Host ""

# Kiểm tra remote
Write-Host "Kiểm tra remote repository..." -ForegroundColor Yellow
$remote = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Chưa có remote. Đang thêm remote..." -ForegroundColor Yellow
    git remote add origin https://github.com/ltn2505/Final_MLOps.git
}

Write-Host "Remote: $remote" -ForegroundColor Cyan
Write-Host ""

# Đổi branch sang main
Write-Host "Đổi branch sang main..." -ForegroundColor Yellow
git branch -M main

# Kiểm tra trạng thái
Write-Host "Kiểm tra trạng thái git..." -ForegroundColor Yellow
git status

Write-Host ""
Write-Host "Đang push code lên GitHub..." -ForegroundColor Yellow
Write-Host "Lưu ý: Nếu được yêu cầu, nhập username và Personal Access Token" -ForegroundColor Cyan
Write-Host ""

# Push code
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Thành công! ===" -ForegroundColor Green
    Write-Host "Repository: https://github.com/ltn2505/Final_MLOps" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "=== Lỗi! ===" -ForegroundColor Red
    Write-Host "Có thể repository chưa được tạo trên GitHub." -ForegroundColor Yellow
    Write-Host "Vui lòng tạo repository trước: https://github.com/new" -ForegroundColor Yellow
    Write-Host "Tên repository: Final_MLOps" -ForegroundColor Yellow
    Write-Host "Sau đó chạy lại script này." -ForegroundColor Yellow
}

