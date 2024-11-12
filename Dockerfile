# Create build stage
FROM registry.suse.com/bci/nodejs:20 AS build

ARG NUXT_UI_PRO_LICENSE

# Set the working directory inside the container
WORKDIR /app

RUN npm i -g pnpm

# Copy package.json and pnpm-lock.yaml files to the working directory
COPY ./package.json ./pnpm-lock.yaml /app/

## Install dependencies
RUN pnpm install --shamefully-hoist

# Copy the rest of the application files to the working directory
COPY . ./

# Build the application
RUN pnpm run build

# Create a new stage for the production image
FROM registry.suse.com/bci/nodejs:20

# Set the working directory inside the container
WORKDIR /app

# Copy the output from the build stage to the working directory
COPY --from=build /app/.output ./

# Define environment variables
ENV HOST=0.0.0.0 NODE_ENV=production
ENV NODE_ENV=production

# Expose the port the application will run on
EXPOSE 3000

# Start the application
CMD ["node","/app/server/index.mjs"]

