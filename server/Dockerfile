# use the node js alpine image
FROM node:alpine

# set work directory for the application
WORKDIR /app

# copying over the files 
COPY . /app/

# install dependencies
RUN npm install

# install Amazon DocumentDB Certificate Authority (CA) certificate required to authenticate to cluster

RUN wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# set port env in codebase
ENV PORT=3000

# expose port
EXPOSE 3000

# start the application
CMD [ "npm", "start" ]
