# Giải thích về Mô hình Machine Learning

## 📊 Tổng quan

Mô hình này là một **Random Forest Classifier** được sử dụng cho bài toán **phân loại nhị phân** (binary classification).

## 🎯 Bài toán

**Mục tiêu**: Phân loại dữ liệu vào 2 lớp (Class 0 hoặc Class 1) dựa trên 10 đặc trưng (features).

## 📈 Dữ liệu

### Nguồn dữ liệu
- Được tạo bằng hàm `make_classification` của scikit-learn
- **Số lượng mẫu**: 1,000 mẫu
- **Số đặc trưng**: 10 features (feature_0 đến feature_9)
- **Số đặc trưng có ý nghĩa**: 5 (n_informative=5)
- **Số lớp**: 2 (binary classification)
- **Random state**: 42 (để đảm bảo kết quả có thể tái lập)

### Phân chia dữ liệu
- **Training set**: 80% (800 mẫu)
- **Test set**: 20% (200 mẫu)
- **Random state**: 42

## 🌲 Mô hình: Random Forest Classifier

### Random Forest là gì?

Random Forest là một thuật toán **ensemble learning** (học tập tập hợp) hoạt động bằng cách:

1. **Tạo nhiều cây quyết định** (Decision Trees) độc lập
2. Mỗi cây được train trên một tập con ngẫu nhiên của dữ liệu (bootstrap sampling)
3. Mỗi cây chỉ xem xét một tập con ngẫu nhiên của các features khi phân chia
4. **Kết hợp kết quả** từ tất cả các cây bằng cách bỏ phiếu (voting)

### Tại sao chọn Random Forest?

✅ **Ưu điểm**:
- Xử lý tốt dữ liệu có nhiều features
- Không cần chuẩn hóa dữ liệu
- Tránh overfitting tốt hơn Decision Tree đơn lẻ
- Có thể xử lý missing values
- Cho biết tầm quan trọng của từng feature

## 🔧 Siêu tham số đã tuning

### n_estimators (Số lượng cây trong rừng)

Đã thử nghiệm 3 giá trị:
- **50 cây**: Accuracy = 0.940 (94.0%)
- **100 cây**: Accuracy = 0.945 (94.5%)
- **200 cây**: Accuracy = 0.950 (95.0%) ⭐ **TỐT NHẤT**

### Lý do tuning n_estimators:

1. **n_estimators = 50**: 
   - Nhanh hơn nhưng có thể chưa đủ để học hết patterns
   - Accuracy thấp nhất: 94.0%

2. **n_estimators = 100**:
   - Cân bằng giữa tốc độ và độ chính xác
   - Accuracy: 94.5%

3. **n_estimators = 200**: 
   - Nhiều cây hơn → học được nhiều patterns hơn
   - Accuracy cao nhất: 95.0%
   - Được chọn làm mô hình tốt nhất

### Các tham số khác (mặc định):
- `random_state=42`: Đảm bảo kết quả có thể tái lập
- `max_depth=None`: Không giới hạn độ sâu cây
- `min_samples_split=2`: Tối thiểu 2 mẫu để tách node
- `min_samples_leaf=1`: Mỗi leaf node có ít nhất 1 mẫu

## 📊 Kết quả Training

| n_estimators | Accuracy | Ghi chú |
|--------------|----------|---------|
| 50 | 94.0% | Nhanh nhưng accuracy thấp |
| 100 | 94.5% | Cân bằng tốt |
| **200** | **95.0%** | **Tốt nhất - được chọn** |

## 🔄 Quy trình hoạt động

### 1. Training Phase (train.py)

```python
# Bước 1: Đọc dữ liệu
data = pd.read_csv("data.csv")
X = data.drop("target", axis=1)  # 10 features
y = data["target"]                # 2 classes (0 hoặc 1)

# Bước 2: Chia train/test
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Bước 3: Training với các n_estimators khác nhau
for n in [50, 100, 200]:
    model = RandomForestClassifier(n_estimators=n)
    model.fit(X_train, y_train)  # Học từ dữ liệu training
    
    # Bước 4: Đánh giá
    predictions = model.predict(X_test)
    accuracy = accuracy_score(y_test, predictions)
    
    # Bước 5: Lưu vào MLflow
    mlflow.log_model(model, name="model")
```

### 2. Model Selection (save_best_model.py)

- Tìm mô hình có accuracy cao nhất trong MLflow
- Tải mô hình tốt nhất (n_estimators=200, accuracy=95.0%)
- Lưu vào thư mục `best_model/`

### 3. Inference Phase (app.py)

```python
# Load mô hình
model = mlflow.sklearn.load_model("best_model")

# Nhận input từ user (10 features)
features = [feature_0, feature_1, ..., feature_9]

# Dự đoán
prediction = model.predict([features])  # Class 0 hoặc 1
probabilities = model.predict_proba([features])  # Xác suất cho mỗi class
```

## 🎯 Cách mô hình dự đoán

### Input:
- 10 giá trị số thực (features) từ người dùng

### Quy trình:
1. **Mỗi cây trong rừng** (200 cây) đưa ra một dự đoán
2. **Bỏ phiếu**: Lớp nào được nhiều cây chọn nhất sẽ thắng
3. **Tính xác suất**: Tỷ lệ số cây bỏ phiếu cho mỗi lớp

### Output:
- **Prediction**: Lớp dự đoán (0 hoặc 1)
- **Probability**: Xác suất cho mỗi lớp
  - P(Class 0): Xác suất mẫu thuộc lớp 0
  - P(Class 1): Xác suất mẫu thuộc lớp 1

### Ví dụ:
```
Input: [1.125, 1.178, 0.494, 0.791, -0.614, 1.347, 1.420, 1.357, 0.966, -1.981]

Quá trình:
- Cây 1: Dự đoán Class 1
- Cây 2: Dự đoán Class 1
- Cây 3: Dự đoán Class 0
- ...
- Cây 200: Dự đoán Class 1

Kết quả bỏ phiếu:
- Class 0: 10 cây (5%)
- Class 1: 190 cây (95%)

Output:
- Prediction: 1
- Probability Class 0: 0.05 (5%)
- Probability Class 1: 0.95 (95%)
```

## 🌐 Ứng dụng Web (app.py)

### Luồng hoạt động:

1. **Khởi động**: Load mô hình tốt nhất từ `best_model/`
2. **Người dùng nhập**: 10 giá trị features qua form web
3. **Xử lý**: 
   - Chuyển đổi input thành numpy array
   - Reshape thành shape (1, 10) - 1 mẫu, 10 features
4. **Dự đoán**:
   - Gọi `model.predict()` → Lớp dự đoán
   - Gọi `model.predict_proba()` → Xác suất
5. **Hiển thị**: Trả về kết quả cho người dùng

### API Endpoints:

- **GET `/`**: Form nhập liệu
- **POST `/predict`**: API dự đoán
- **GET `/health`**: Kiểm tra trạng thái

## 📝 Tóm tắt

| Thông tin | Giá trị |
|-----------|---------|
| **Thuật toán** | Random Forest Classifier |
| **Số cây** | 200 (n_estimators) |
| **Số features** | 10 |
| **Số classes** | 2 (binary) |
| **Accuracy** | 95.0% |
| **Dữ liệu training** | 800 mẫu |
| **Dữ liệu test** | 200 mẫu |
| **Framework** | scikit-learn + MLflow |
| **Deployment** | Flask Web Application |

## 🔍 Đánh giá mô hình

### Điểm mạnh:
- ✅ Accuracy cao (95%)
- ✅ Ổn định (ensemble method)
- ✅ Có thể giải thích được (feature importance)
- ✅ Xử lý tốt dữ liệu không cần chuẩn hóa

### Hạn chế:
- ⚠️ Có thể chậm hơn với số lượng cây lớn
- ⚠️ Cần nhiều bộ nhớ để lưu trữ nhiều cây
- ⚠️ Khó giải thích chi tiết hơn so với Decision Tree đơn lẻ

## 🚀 Cải thiện có thể thực hiện

1. **Tuning thêm hyperparameters**:
   - `max_depth`: Giới hạn độ sâu cây
   - `min_samples_split`: Số mẫu tối thiểu để tách node
   - `max_features`: Số features xem xét khi tách node

2. **Feature Engineering**:
   - Tạo thêm features mới
   - Chọn lọc features quan trọng

3. **Thử các thuật toán khác**:
   - Gradient Boosting (XGBoost, LightGBM)
   - Support Vector Machine (SVM)
   - Neural Networks

4. **Cross-validation**:
   - Sử dụng k-fold cross-validation để đánh giá tốt hơn

