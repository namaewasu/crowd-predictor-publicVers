#!/usr/bin/env sh
set -e

cd /app/backend

# Download model if not present and MODEL_URL provided
if [ ! -f "trafik_model.pkl" ] && [ -n "$MODEL_URL" ]; then
  echo "Downloading model from $MODEL_URL ..."
  curl -L --fail --retry 3 --connect-timeout 10 "$MODEL_URL" -o trafik_model.pkl || echo "Model download failed"
fi

# Download scaler if not present and SCALER_URL provided (optional)
if [ ! -f "scaler.pkl" ] && [ -n "$SCALER_URL" ]; then
  echo "Downloading scaler from $SCALER_URL ..."
  curl -L --fail --retry 3 --connect-timeout 10 "$SCALER_URL" -o scaler.pkl || echo "Scaler download failed"
fi

exec gunicorn -w 2 -k gthread --threads 4 --timeout 90 -b 0.0.0.0:${PORT:-8080} app:app


