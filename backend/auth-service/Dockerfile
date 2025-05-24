# Use Node.js 24.1.0
FROM docker.io/library/node:24-alpine

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy app source
COPY . .

# Expose app port
EXPOSE 3000

# Start the app
CMD ["npm", "run", "dev"]
