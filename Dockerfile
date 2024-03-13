# Stage 1: Build the Node.js application
FROM node:latest AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Create the final lightweight image
FROM node:alpine

# Set working directory
WORKDIR /app

# Copy only the necessary files from the previous stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/build ./build

# Install production dependencies only
RUN npm install --production

# Expose port (if needed)
EXPOSE 3000

# Command to run the application
CMD ["node", "build/index.js"]
