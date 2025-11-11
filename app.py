import os
import sys
from flask import Flask, render_template, request, jsonify
import mlflow.sklearn
import numpy as np

# Fix encoding cho Windows
if sys.platform == "win32":
    import codecs
    sys.stdout = codecs.getwriter("utf-8")(sys.stdout.buffer, "strict")
    sys.stderr = codecs.getwriter("utf-8")(sys.stderr.buffer, "strict")

app = Flask(__name__)

# Load mô hình tốt nhất
MODEL_PATH = "best_model"
try:
    model = mlflow.sklearn.load_model(MODEL_PATH)
    print(f"Da tai mo hinh thanh cong tu {MODEL_PATH}")
except Exception as e:
    print(f"Loi khi tai mo hinh: {e}")
    model = None

@app.route('/')
def index():
    """Trang chủ với form nhập liệu"""
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    """API endpoint để dự đoán"""
    if model is None:
        return jsonify({'error': 'Mo hinh chua duoc tai'}), 500
    
    try:
        # Lấy dữ liệu từ form
        data = request.get_json() if request.is_json else request.form
        
        # Lấy 10 features
        features = []
        for i in range(10):
            feature_name = f'feature_{i}'
            if feature_name in data:
                features.append(float(data[feature_name]))
            else:
                return jsonify({'error': f'Thieu feature_{i}'}), 400
        
        # Chuyển đổi sang numpy array và reshape
        features_array = np.array(features).reshape(1, -1)
        
        # Dự đoán
        prediction = model.predict(features_array)[0]
        prediction_proba = model.predict_proba(features_array)[0]
        
        # Kết quả
        result = {
            'prediction': int(prediction),
            'probability_class_0': float(prediction_proba[0]),
            'probability_class_1': float(prediction_proba[1]),
            'features': features
        }
        
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': model is not None
    })

if __name__ == '__main__':
    if model is None:
        print("Canh bao: Mo hinh chua duoc tai. Ung dung co the khong hoat dong dung.")
    app.run(debug=True, host='0.0.0.0', port=5000)

