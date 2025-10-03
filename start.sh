#!/bin/sh

# Start the backend application in the background using the virtual environment
cd /app/backend
export FLASK_ENV=production
/app/venv/bin/python app.py &

# Start Nginx in the foreground
nginx -g "daemon off;"