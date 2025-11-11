import mlflow
import mlflow.sklearn
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.ensemble import RandomForestClassifier
import pandas as pd

# Đọc dữ liệu
data = pd.read_csv("data.csv")
X = data.drop("target", axis=1)
y = data["target"]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Khai báo experiment cho MLflow
mlflow.set_experiment("MLOps_Project")

# Thử nghiệm các mô hình với số cây khác nhau
n_estimators_list = [50, 100, 200]

for n in n_estimators_list:
    with mlflow.start_run():
        model = RandomForestClassifier(n_estimators=n, random_state=42)
        model.fit(X_train, y_train)

        preds = model.predict(X_test)
        acc = accuracy_score(y_test, preds)

        # Ghi lại tham số và độ chính xác
        mlflow.log_param("n_estimators", n)
        mlflow.log_metric("accuracy", acc)

        # Lưu mô hình vào MLflow (dùng name thay vì artifact_path để tránh warning)
        mlflow.sklearn.log_model(model, name="model")

        print(f"n_estimators={n} -> accuracy={acc:.4f}")
