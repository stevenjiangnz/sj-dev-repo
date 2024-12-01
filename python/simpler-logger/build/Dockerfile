FROM python:3.9-slim

# Set Python to run in unbuffered mode
ENV PYTHONUNBUFFERED=1

# Set working directory in container
WORKDIR /app

# Copy the Python script to the container
COPY ../src/logger.py .

# Run the script
CMD ["python", "logger.py"]