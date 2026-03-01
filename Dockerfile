# ---------- FRONTEND BUILD STAGE ----------
FROM node:18-alpine AS frontend-builder

WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build


# ---------- BACKEND STAGE ----------
FROM python:3.10-slim

WORKDIR /app

# Install backend dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend/app folder
COPY backend/app /app/app

# Copy other backend files if needed
#COPY backend/vehicle.db /app/vehicle.db

# Copy built frontend from first stage into static folder
COPY --from=frontend-builder /frontend/dist /app/app/static

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
