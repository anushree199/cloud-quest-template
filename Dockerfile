# Stage 1: Install dependencies
FROM node:18-alpine AS deps

WORKDIR /app

# Copy only the package files to install deps
COPY package*.json ./
RUN npm install --production

# Stage 2: Copy app and run
FROM node:18-alpine AS runner

WORKDIR /app

# Copy only necessary files from deps stage
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY src ./src
COPY bin ./bin

# Ensure binaries are executable
RUN chmod +x ./bin/*

EXPOSE 3000
CMD ["node", "src/000.js"]
