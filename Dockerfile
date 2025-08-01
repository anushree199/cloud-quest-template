# # ---------- Stage 1: Builder ----------
# FROM node:20-alpine AS builder

# WORKDIR /app

# # Install dependencies
# COPY package*.json ./
# RUN npm install --production

# # Copy source files
# COPY . .

# # ---------- Stage 2: Runtime ----------
# FROM node:20-alpine

# WORKDIR /app

# # Copy built app and certs
# COPY --from=builder /app /app
# COPY cert/ /app/cert/

# # Create app user for better security
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# USER appuser

# # Expose HTTP and HTTPS ports
# EXPOSE 3000
# EXPOSE 3000

# # Start app
# CMD ["node", "src/000.js"]

# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --production

# Copy application source
COPY . .

# ---------- Stage 2: Runtime ----------
FROM node:20-alpine

WORKDIR /app

# Copy app and certificates from builder
COPY --from=builder /app /app

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose HTTP and HTTPS ports
EXPOSE 3000
EXPOSE 3443

# Start the application
CMD ["node", "src/000.js"]
