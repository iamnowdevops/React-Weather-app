# Fetching the latest node image on alpine linux
FROM node:alpine AS development

# Declaring env
# ENV NODE_ENV development

# Setting up the work directory
WORKDIR /react-app

# Installing dependencies
COPY . .
RUN npm install

# Copying all the files in our project
COPY . .

# Starting our application
# Expose port 

EXPOSE 3000

CMD ["npm", "start"]
