from sklearn.datasets import make_classification
import pandas as pd

X, y = make_classification(
    n_samples=1000, n_features=10, n_informative=5, n_classes=2, random_state=42
)

df = pd.DataFrame(X, columns=[f"feature_{i}" for i in range(10)])
df["target"] = y
df.to_csv("data.csv", index=False)
print("✅ Dữ liệu đã được tạo và lưu vào data.csv")
