# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PORT 7860
ENV HOME=/home/user

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set up user 1000 (standard for HF Spaces)
RUN useradd -m -u 1000 user
USER user
WORKDIR $HOME/app

# Set up path
ENV PATH="/home/user/.local/bin:${PATH}"

# Install Python dependencies
COPY --chown=user requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY --chown=user . .

# Expose the port
EXPOSE 7860

# Run the application
CMD ["python", "app.py"]
