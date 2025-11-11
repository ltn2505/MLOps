# Hướng dẫn đồng bộ dự án lên GitHub

## Bước 1: Tạo Repository trên GitHub

1. Đăng nhập vào GitHub: https://github.com
2. Click vào biểu tượng **+** ở góc trên bên phải → chọn **New repository**
3. Điền thông tin:
   - **Repository name**: `Final_MLOps`
   - **Description**: `MLOps Project with MLflow and Flask - Random Forest Classifier`
   - **Visibility**: Chọn **Public** ✅
   - **KHÔNG** tích vào "Initialize this repository with a README" (vì đã có code local)
4. Click **Create repository**

## Bước 2: Push code lên GitHub

Sau khi tạo repository, chạy các lệnh sau:

```bash
# Đảm bảo đang ở branch main
git branch -M main

# Push code lên GitHub
git push -u origin main
```

Nếu được yêu cầu xác thực:
- **Username**: `ltn2505`
- **Password**: Sử dụng **Personal Access Token** (không phải password GitHub)

### Tạo Personal Access Token (nếu cần):

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click **Generate new token (classic)**
3. Đặt tên token và chọn quyền: **repo** (full control)
4. Click **Generate token**
5. Copy token và sử dụng làm password khi push

## Bước 3: Kiểm tra

Sau khi push thành công, truy cập:
**https://github.com/ltn2505/Final_MLOps**

Bạn sẽ thấy tất cả các file đã được upload.

## Cấu trúc Repository

```
Final_MLOps/
├── app.py                    # Flask web application
├── train.py                  # Training script với MLflow
├── save_best_model.py        # Script lưu mô hình tốt nhất
├── data_generator.py         # Tạo dữ liệu
├── requirements.txt          # Dependencies
├── README.md                 # Hướng dẫn sử dụng
├── MODEL_EXPLANATION.md      # Giải thích mô hình
├── .gitignore               # Git ignore rules
├── data.csv                 # Dữ liệu training
├── best_model/              # Mô hình tốt nhất
│   ├── model.pkl
│   ├── MLmodel
│   └── requirements.txt
└── templates/
    └── index.html           # Giao diện web
```

## Lưu ý

- Các thư mục `venv/`, `__pycache__/`, `mlruns/` đã được loại trừ trong `.gitignore`
- Repository là **Public**, ai cũng có thể xem code
- Để cập nhật code sau này, dùng:
  ```bash
  git add .
  git commit -m "Mô tả thay đổi"
  git push
  ```

