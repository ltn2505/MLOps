# Script để kết nối với GitLab repository
# Sử dụng: .\setup_gitlab.ps1

Write-Host "=== Setup GitLab Repository ===" -ForegroundColor Cyan
Write-Host ""

# Nhập username GitLab
$username = Read-Host "Nhap username GitLab cua ban"

if ([string]::IsNullOrWhiteSpace($username)) {
    Write-Host "Username khong duoc de trong!" -ForegroundColor Red
    exit 1
}

# Chọn phương thức kết nối
Write-Host ""
Write-Host "Chon phuong thuc ket noi:" -ForegroundColor Yellow
Write-Host "1. HTTPS (khuyen dung)"
Write-Host "2. SSH"
$choice = Read-Host "Nhap lua chon (1 hoac 2)"

$remoteUrl = ""
if ($choice -eq "1") {
    $remoteUrl = "https://gitlab.com/$username/MLOps.git"
} elseif ($choice -eq "2") {
    $remoteUrl = "git@gitlab.com:$username/MLOps.git"
} else {
    Write-Host "Lua chon khong hop le!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Remote URL: $remoteUrl" -ForegroundColor Green
Write-Host ""

# Kiểm tra xem remote đã tồn tại chưa
$existingRemote = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Remote 'origin' da ton tai: $existingRemote" -ForegroundColor Yellow
    $overwrite = Read-Host "Ban co muon ghi de? (y/n)"
    if ($overwrite -eq "y" -or $overwrite -eq "Y") {
        git remote set-url origin $remoteUrl
        Write-Host "Da cap nhat remote URL" -ForegroundColor Green
    } else {
        Write-Host "Huy bo" -ForegroundColor Yellow
        exit 0
    }
} else {
    git remote add origin $remoteUrl
    Write-Host "Da them remote 'origin'" -ForegroundColor Green
}

# Đổi tên branch thành main
git branch -M main

Write-Host ""
Write-Host "=== Thong tin repository ===" -ForegroundColor Cyan
git remote -v
Write-Host ""
git branch

Write-Host ""
Write-Host "=== San sang push len GitLab ===" -ForegroundColor Green
Write-Host "Chay lenh sau de push code:" -ForegroundColor Yellow
Write-Host "  git push -u origin main" -ForegroundColor White
Write-Host ""

$pushNow = Read-Host "Ban co muon push ngay bay gio? (y/n)"
if ($pushNow -eq "y" -or $pushNow -eq "Y") {
    Write-Host "Dang push len GitLab..." -ForegroundColor Cyan
    git push -u origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=== Thanh cong! ===" -ForegroundColor Green
        Write-Host "Repository da duoc push len GitLab" -ForegroundColor Green
        Write-Host "URL: https://gitlab.com/$username/MLOps" -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "=== Loi khi push ===" -ForegroundColor Red
        Write-Host "Vui long kiem tra:" -ForegroundColor Yellow
        Write-Host "1. Repository 'MLOps' da duoc tao tren GitLab chua?"
        Write-Host "2. Ban co quyen truy cap repository khong?"
        Write-Host "3. Xac thuc (username/password hoac SSH key) da duoc cau hinh chua?"
    }
} else {
    Write-Host "Ban co the push sau bang lenh: git push -u origin main" -ForegroundColor Yellow
}

