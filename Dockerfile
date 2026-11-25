FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /usr/local/lib/python3.11/ensurepip

COPY src/ ./src/
ENV PYTHONUNBUFFERED=1
CMD ["python", "src/app.py"]
