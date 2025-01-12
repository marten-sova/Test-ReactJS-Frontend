FROM node:16

ENV PORT 3000

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Installing dependencies
RUN apt-get update
# we can remove these once we're done tinkering
RUN apt-get install -y apt-utils vim

# add `/app/node_modules/.bin` to $PATH
#ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm ci 
RUN npm audit fix --fix

# Copy app over
COPY . .

RUN npm run build

# Docker annoyingly tries to persist perms on node_modules as being "root"
# if we happen to have a local copy of node_modules
RUN chown -R node:node /app/node_modules
RUN chown -R node:node /app/.next
#RUN mv .env.docker .env

# Not technically needed, but shows intent
EXPOSE 3000

# Note you should be more extensive here if worried about deploying to Prod!
# CMD ["npm", "run", "start"]

# If you are doing dev work, uncomment the following line
CMD ["npm", "run", "dev"]