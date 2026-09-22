FROM python:3.13-slim

# Set environment variables to prevent .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000

WORKDIR /app

# Install curl for container health checks
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security best practices
RUN useradd -m -u 1000 appuser

# Install dependencies first to leverage Docker layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code and assets (locales, blog content, templates, static)
COPY . .

# Set proper ownership and permissions for the non-root user
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

# Run the application in production mode using FastAPI CLI
CMD ["fastapi", "run", "app.py", "--host", "0.0.0.0", "--port", "8000"]
