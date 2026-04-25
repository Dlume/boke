FROM python:3.11-slim

WORKDIR /app

# Copy application code
COPY webapp/ ./webapp/
COPY scripts/ ./scripts/
COPY db/ ./db/

# Install dependencies (none required for stdlib, but good practice)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Initialize database
RUN python webapp/init_db.py

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Run application
CMD ["python", "webapp/app.py"]
