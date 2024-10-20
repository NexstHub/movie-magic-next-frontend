# Stage 1: Install dependencies and build the Next.js project
FROM node:20 AS builder

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2: Run the Next.js app
FROM node:20-alpine AS runner

WORKDIR /usr/src/app

# Copy the built Next.js app from the builder stage
COPY --from=builder /usr/src/app/.next /usr/src/app/.next
COPY --from=builder /usr/src/app/public /usr/src/app/public
COPY --from=builder /usr/src/app/package*.json /usr/src/app/

# Install only production dependencies
RUN npm install --production

# Expose the port the Next.js app will run on
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]

