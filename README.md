# MLflow Classification Project

Dự án MLOps sử dụng MLflow để quản lý và triển khai mô hình phân loại.

> **CI/CD**: Tự động build Docker image mỗi khi push lên nhánh `main` 🚀

## 📋 Cấu trúc dự án

```
final/
├── data_generator.py      # Tạo dữ liệu với make_classification
├── train.py               # Training mô hình và tuning hyperparameters
├── save_best_model.py     # Tìm và lưu mô hình tốt nhất
├── app.py                 # Flask web application
├── data.csv               # Dữ liệu training
├── best_model/            # Mô hình tốt nhất đã được lưu
├── templates/
│   └── index.html         # Giao diện web
├── Dockerfile             # Docker image configuration
├── docker-compose.yml     # Docker Compose configuration
└── .github/workflows/     # GitHub Actions CI/CD
```

## 🚀 Cài đặt

### 1. Tạo virtual environment

```bash
python -m venv venv
```

### 2. Kích hoạt virtual environment

- **Windows PowerShell**: `.\venv\Scripts\Activate.ps1`
- **Windows CMD**: `venv\Scripts\activate.bat`
- **Linux/Mac**: `source venv/bin/activate`

### 3. Cài đặt dependencies

```bash
pip install -r requirements.txt
```

## 📖 Sử dụng

### 1. Tạo dữ liệu

```bash
python data_generator.py
```

Tạo 1,000 mẫu với 10 features cho bài toán phân loại nhị phân.

### 2. Training mô hình

```bash
python train.py
```

Script này sẽ:
- Đọc dữ liệu từ `data.csv`
- Chia train/test (80/20)
- Thử nghiệm với các siêu tham số: `n_estimators = [50, 100, 200]`
- Lưu kết quả vào MLflow với metrics và parameters

### 3. Lưu mô hình tốt nhất

```bash
python save_best_model.py
```

Script này sẽ:
- Tìm mô hình có accuracy cao nhất trong MLflow
- Tải và lưu mô hình vào thư mục `best_model/`

### 4. Chạy ứng dụng web

```bash
python app.py
```

Sau đó mở trình duyệt: `http://localhost:5000`

## 🎯 Mô hình

- **Algorithm**: Random Forest Classifier
- **Hyperparameters tuned**: `n_estimators` (50, 100, 200)
- **Best model**: `n_estimators=200`, Accuracy: **95.0%**
- **Features**: 10 features
- **Classes**: 2 (binary classification)

## 🌐 API Endpoints

### GET `/`
Trang chủ với form nhập liệu 10 features

### POST `/predict`
API endpoint để dự đoán phân loại

**Request (JSON):**
```json
{
  "feature_0": 1.125,
  "feature_1": 1.178,
  "feature_2": 0.494,
  "feature_3": 0.791,
  "feature_4": -0.614,
  "feature_5": 1.347,
  "feature_6": 1.420,
  "feature_7": 1.357,
  "feature_8": 0.966,
  "feature_9": -1.981
}
```

**Response:**
```json
{
  "prediction": 1,
  "probability_class_0": 0.05,
  "probability_class_1": 0.95,
  "features": [1.125, 1.178, ...]
}
```

### GET `/health`
Health check endpoint

## 🐳 Docker

### Build image local

```bash
docker build -t mlops-app:latest .
```

### Chạy container

```bash
docker run -d -p 5000:5000 --name mlops-app mlops-app:latest
```

### Hoặc dùng docker-compose

```bash
docker-compose up -d
```

### Xem logs

```bash
docker logs mlops-app
docker logs -f mlops-app  # Follow logs
```

### Dừng và xóa container

```bash
docker stop mlops-app
docker rm mlops-app
# Hoặc cùng lúc:
docker rm -f mlops-app
```

## 🔄 CI/CD với GitHub Actions

Dự án được cấu hình với **GitHub Actions** để tự động build và push Docker image mỗi khi push code lên nhánh `main`.

### Workflow tự động:

1. ✅ **Trigger**: Mỗi khi push lên nhánh `main`
2. ✅ **Build**: Tự động build Docker image
3. ✅ **Push**: Upload image lên **Docker Hub** và GitHub Container Registry

### Cấu hình Docker Hub (Lần đầu)

1. **Tạo tài khoản Docker Hub**: https://hub.docker.com/signup
2. **Tạo Access Token**:
   - Đăng nhập Docker Hub → Account Settings → Security → New Access Token
   - Chọn quyền: **Read & Write**
   - Copy token (chỉ hiển thị 1 lần, dạng `dckr_pat_...`)
3. **Thêm secrets vào GitHub**:
   - Vào: https://github.com/ltn2505/MLOps/settings/secrets/actions
   - Thêm secret `DOCKER_HUB_USERNAME`: Username Docker Hub của bạn
   - Thêm secret `DOCKER_HUB_TOKEN`: Access Token đã tạo
4. **Push code**: Workflow sẽ tự động chạy và push image lên Docker Hub

> **Lưu ý**: Không cần tạo repository trên Docker Hub trước. Docker Hub sẽ tự động tạo repository khi push image lần đầu.

### Pull và chạy từ Docker Hub

```bash
# Pull image từ Docker Hub
docker pull YOUR_USERNAME/mlops:latest

# Chạy container
docker run -d -p 5000:5000 --name mlops-app YOUR_USERNAME/mlops:latest
```

**Thay `YOUR_USERNAME` bằng username Docker Hub của bạn.**

### Pull từ GitHub Container Registry

```bash
docker pull ghcr.io/ltn2505/mlops:latest
docker run -d -p 5000:5000 --name mlops-app ghcr.io/ltn2505/mlops:latest
```

### Tags

Workflow tạo tag `latest` cho mỗi image để đơn giản và dễ sử dụng.

## 🔧 Troubleshooting

### Lỗi: "Error: Password required" trong GitHub Actions

**Nguyên nhân**: Secrets Docker Hub chưa được cấu hình.

**Giải pháp**:
1. Kiểm tra secrets đã được thêm chưa: `DOCKER_HUB_USERNAME` và `DOCKER_HUB_TOKEN`
2. Đảm bảo tên secrets chính xác (phân biệt chữ hoa/thường)
3. Re-run workflow sau khi thêm secrets

### Lỗi: "Container name already in use"

**Nguyên nhân**: Container với tên đó đã tồn tại.

**Giải pháp**:
```bash
# Xóa container cũ
docker rm -f mlops-app

# Chạy lại với lệnh đúng
docker run -d -p 5000:5000 --name mlops-app YOUR_USERNAME/mlops:latest
```

**Lưu ý**: Container name (`--name`) phải là tên có ý nghĩa, không phải số port.

### Lỗi: "Port already in use"

**Nguyên nhân**: Port 5000 đã được sử dụng.

**Giải pháp**:
```bash
# Dùng port khác
docker run -d -p 5001:5000 --name mlops-app YOUR_USERNAME/mlops:latest
# Sau đó truy cập: http://localhost:5001
```

### Lấy Username Docker Hub

1. Đăng nhập Docker Hub: https://hub.docker.com
2. Click vào username ở góc trên bên phải
3. Xem URL: `https://hub.docker.com/u/YOUR_USERNAME`
4. `YOUR_USERNAME` chính là username của bạn

## 📝 Tính năng

- ✅ Tạo dữ liệu với `make_classification`
- ✅ Training và tuning hyperparameters với MLflow
- ✅ Tracking experiments và metrics
- ✅ So sánh và lưu mô hình tốt nhất
- ✅ Flask web application với giao diện đẹp
- ✅ API endpoint để dự đoán
- ✅ Hiển thị xác suất dự đoán
- ✅ Docker containerization
- ✅ CI/CD với GitHub Actions (tự động build và push Docker image)
- ✅ Push lên Docker Hub và GitHub Container Registry

## 📚 Tài liệu tham khảo

- **MLflow**: https://mlflow.org/
- **Docker**: https://docs.docker.com/
- **GitHub Actions**: https://docs.github.com/en/actions
- **Flask**: https://flask.palletsprojects.com/
- **scikit-learn**: https://scikit-learn.org/

