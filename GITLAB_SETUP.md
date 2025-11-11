# Hướng dẫn đồng bộ với GitLab

## Bước 1: Tạo repository trên GitLab

1. Đăng nhập vào GitLab của bạn
2. Tạo một repository mới tên **"MLOps"**
3. Đặt visibility là **Public**
4. **KHÔNG** khởi tạo với README, .gitignore, hoặc license (vì đã có sẵn)

## Bước 2: Thêm remote và push code

Sau khi tạo repository, chạy các lệnh sau (thay `YOUR_USERNAME` bằng username GitLab của bạn):

### Nếu dùng HTTPS:
```bash
git remote add origin https://gitlab.com/YOUR_USERNAME/MLOps.git
git branch -M main
git push -u origin main
```

### Nếu dùng SSH:
```bash
git remote add origin git@gitlab.com:YOUR_USERNAME/MLOps.git
git branch -M main
git push -u origin main
```

## Bước 3: Xác thực (nếu cần)

- **HTTPS**: Bạn sẽ được yêu cầu nhập username và password/token
- **SSH**: Đảm bảo đã thêm SSH key vào GitLab

## Lưu ý

- File `.gitignore` đã được tạo để loại trừ:
  - `venv/` - Virtual environment
  - `__pycache__/` - Python cache
  - `mlruns/` - MLflow tracking data (quá lớn)
  - Các file tạm và IDE

- Nếu muốn commit `best_model/` hoặc `data.csv`, hãy comment dòng tương ứng trong `.gitignore`

## Các lệnh Git hữu ích

```bash
# Xem trạng thái
git status

# Xem remote đã thêm
git remote -v

# Thêm file mới
git add <file>

# Commit thay đổi
git commit -m "Mô tả thay đổi"

# Push lên GitLab
git push

# Pull từ GitLab
git pull
```

