# Sử dụng Python 3.12 slim image
FROM python:3.12-slim

# Thiết lập thư mục làm việc
WORKDIR /app

# Cài đặt các dependencies hệ thống
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements và cài đặt dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ ứng dụng
COPY . .

# Tạo thư mục cho MLflow nếu cần
RUN mkdir -p mlruns

# Expose port 5000 cho Flask
EXPOSE 5000

# Thiết lập biến môi trường
ENV FLASK_APP=app.py
ENV PYTHONUNBUFFERED=1

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:5000/health')" || exit 1

# Chạy ứng dụng
CMD ["python", "app.py"]

