FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Install minimal build tools when needed by wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgomp1 \
    curl \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install backend dependencies
COPY backend/requirements.txt backend/requirements.txt
RUN pip install -r backend/requirements.txt

# Copy application code
COPY backend backend
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Run from backend directory at runtime via entrypoint
WORKDIR /app

# Default port (Railway will inject PORT)
ENV PORT=8080

# Start Gunicorn binding to the provided PORT
ENTRYPOINT ["/app/docker-entrypoint.sh"]


