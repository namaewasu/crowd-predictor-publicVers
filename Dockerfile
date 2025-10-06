FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Install minimal build tools when needed by wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
  && rm -rf /var/lib/apt/lists/*

# Install backend dependencies
COPY backend/requirements.txt backend/requirements.txt
RUN pip install -r backend/requirements.txt

# Copy application code
COPY backend backend

# Run from backend directory
WORKDIR /app/backend

# Default port (Railway will inject PORT)
ENV PORT=8080

# Start Gunicorn binding to the provided PORT
CMD gunicorn -w 2 -k gthread --threads 4 --timeout 90 -b 0.0.0.0:${PORT} app:app


