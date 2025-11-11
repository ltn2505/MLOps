import os
import shutil
import sys
import mlflow
from mlflow.tracking import MlflowClient

# Fix encoding cho Windows
if sys.platform == "win32":
    import codecs
    sys.stdout = codecs.getwriter("utf-8")(sys.stdout.buffer, "strict")
    sys.stderr = codecs.getwriter("utf-8")(sys.stderr.buffer, "strict")

# Thiết lập tracking URI
mlflow.set_tracking_uri("./mlruns")

# Tìm experiment "MLOps_Project"
try:
    experiment = mlflow.get_experiment_by_name("MLOps_Project")
    if experiment is None:
        print("Khong tim thay experiment 'MLOps_Project'!")
        exit(1)
    experiment_id = experiment.experiment_id
    print(f"Tim thay experiment: {experiment.name} (ID: {experiment_id})")
except Exception as e:
    print(f"Loi khi tim experiment: {e}")
    exit(1)

# Tìm run có độ chính xác cao nhất
client = MlflowClient()
runs = mlflow.search_runs(
    experiment_ids=[experiment_id],
    order_by=["metrics.accuracy DESC"],
    max_results=1
)

if len(runs) == 0:
    print("Khong tim thay run nao trong experiment!")
    exit(1)

best_run = runs.iloc[0]
best_run_id = best_run["run_id"]
best_acc = best_run["metrics.accuracy"]

print(f"Run tot nhat: {best_run_id}")
print(f"Accuracy: {best_acc:.4f}")

# Tải mô hình bằng MLflow API
model_uri = f"runs:/{best_run_id}/model"
dst_path = "best_model"

if os.path.exists(dst_path):
    shutil.rmtree(dst_path)

try:
    # Tải mô hình từ MLflow
    model = mlflow.sklearn.load_model(model_uri)
    print(f"Da tai mo hinh thanh cong tu MLflow")
    
    # Lưu mô hình vào thư mục best_model
    mlflow.sklearn.save_model(model, dst_path)
    print(f"Mo hinh tot nhat (accuracy={best_acc:.4f}) da duoc luu vao thu muc 'best_model'")
except Exception as e:
    print(f"Loi khi tai/luu mo hinh: {e}")
    print(f"Model URI: {model_uri}")
    exit(1)
