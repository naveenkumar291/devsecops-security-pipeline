FROM node:20-alpine

WORKDIR /app

COPY app/package*.json ./

RUN npm ci --omit=dev

COPY app/ .

EXPOSE 3000

USER node

CMD ["node", "server.js"]