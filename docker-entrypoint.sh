#!/usr/bin/env sh
set -e

cd /app/backend

# Download model if MODEL_URL provided (always try refresh to avoid partials)
if [ -n "$MODEL_URL" ]; then
  echo "MODEL_URL set. Attempting to download model from: $MODEL_URL"
  rm -f model_download.tmp
  if curl -L --fail --retry 5 --retry-delay 2 --connect-timeout 20 \
      -o model_download.tmp "$MODEL_URL"; then
    # Check if it's a zip file and extract, or use as-is
    if file model_download.tmp | grep -q "Zip archive"; then
      echo "Detected ZIP file, extracting..."
      unzip -o model_download.tmp
      rm -f model_download.tmp
      echo "ZIP extracted successfully"
    else
      # Not a zip, assume it's the model file directly
      FILESIZE=$(wc -c < model_download.tmp || echo 0)
      echo "Downloaded bytes: $FILESIZE"
      if [ "$FILESIZE" -gt 1000000 ]; then
        mv model_download.tmp trafik_model.pkl
        echo "Model saved to trafik_model.pkl"
      else
        echo "Downloaded model too small; keeping existing if any."
        rm -f model_download.tmp
      fi
    fi
  else
    echo "Model download failed via curl"
  fi
fi

# Download scaler if not present and SCALER_URL provided (optional)
if [ -n "$SCALER_URL" ]; then
  echo "SCALER_URL set. Attempting to download scaler.pkl from: $SCALER_URL"
  rm -f scaler.pkl.tmp
  if curl -L --fail --retry 5 --retry-delay 2 --connect-timeout 20 \
      -o scaler.pkl.tmp "$SCALER_URL"; then
    FILESIZE=$(wc -c < scaler.pkl.tmp || echo 0)
    echo "Downloaded scaler bytes: $FILESIZE"
    if [ "$FILESIZE" -gt 1000 ]; then
      mv scaler.pkl.tmp scaler.pkl
      echo "Scaler saved to scaler.pkl"
    else
      echo "Downloaded scaler looks too small; discarding."
      rm -f scaler.pkl.tmp
    fi
  else
    echo "Scaler download failed via curl"
  fi
fi

exec gunicorn -w 2 -k gthread --threads 4 --timeout 90 -b 0.0.0.0:${PORT:-8080} app:app


