# MLflow Classification Project

Dự án MLOps sử dụng MLflow để quản lý và triển khai mô hình phân loại.

## Cấu trúc dự án

```
final/
├── data_generator.py      # Tạo dữ liệu với make_classification
├── train.py               # Training mô hình và tuning hyperparameters
├── save_best_model.py     # Tìm và lưu mô hình tốt nhất
├── app.py                 # Flask web application
├── data.csv               # Dữ liệu training
├── best_model/            # Mô hình tốt nhất đã được lưu
├── mlruns/                # MLflow tracking data
└── templates/
    └── index.html         # Giao diện web
```

## Cài đặt

1. Tạo virtual environment (nếu chưa có):
```bash
python -m venv venv
```

2. Kích hoạt virtual environment:
- Windows PowerShell: `.\venv\Scripts\Activate.ps1`
- Windows CMD: `venv\Scripts\activate.bat`
- Linux/Mac: `source venv/bin/activate`

3. Cài đặt dependencies:
```bash
pip install -r best_model/requirements.txt
pip install flask
```

## Sử dụng

### 1. Tạo dữ liệu (nếu chưa có)
```bash
python data_generator.py
```

### 2. Training mô hình
```bash
python train.py
```

Script này sẽ:
- Đọc dữ liệu từ `data.csv`
- Thử nghiệm với các siêu tham số khác nhau (n_estimators: 50, 100, 200)
- Lưu kết quả vào MLflow

### 3. Lưu mô hình tốt nhất
```bash
python save_best_model.py
```

Script này sẽ:
- Tìm mô hình có accuracy cao nhất trong MLflow
- Lưu mô hình vào thư mục `best_model/`

### 4. Chạy ứng dụng web
```bash
python app.py
```

Sau đó mở trình duyệt và truy cập: `http://localhost:5000`

## API Endpoints

### GET `/`
Trang chủ với form nhập liệu

### POST `/predict`
API endpoint để dự đoán phân loại

**Request body (JSON):**
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

## Mô hình

- **Algorithm**: Random Forest Classifier
- **Hyperparameters tuned**: n_estimators (50, 100, 200)
- **Best model**: Được lưu trong `best_model/` với accuracy cao nhất

## Tính năng

- ✅ Tạo dữ liệu với make_classification
- ✅ Training và tuning hyperparameters
- ✅ Tracking với MLflow
- ✅ So sánh và lưu mô hình tốt nhất
- ✅ Flask web application với giao diện đẹp
- ✅ API endpoint để dự đoán
- ✅ Hiển thị xác suất dự đoán

## Lưu ý

- Đảm bảo đã chạy `train.py` và `save_best_model.py` trước khi chạy `app.py`
- Mô hình sẽ được load tự động khi khởi động ứng dụng
- Ứng dụng chạy ở chế độ debug mode (development only)

