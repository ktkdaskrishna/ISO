# Using Ubuntu 20.04 due to compatibility issues with weasyprint
FROM ubuntu:20.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies needed only for building the app
RUN apt-get update && apt-get install -y \
    libpq-dev \
    python3-pip \
    gcc

# Copy requirements and install them
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Runtime stage
FROM ubuntu:20.04 AS app
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y libpq5 python3.8 weasyprint=51-2 \
  && rm -rf /var/lib/apt/lists/*

# Copy installed dependencies from the builder stage
COPY --from=builder /usr/local /usr/local/

# Copy application code
COPY . .

# Command to run the application
CMD ["/bin/bash", "run.sh"]
