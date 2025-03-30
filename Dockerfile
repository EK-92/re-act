FROM node:20-alpine AS dev
COPY . /app
WORKDIR /app
RUN npm ci

FROM node:20-alpine AS prod
COPY ./package.json package-lock.json /app/
WORKDIR /app
RUN npm ci --omit=dev

FROM node:20-alpine AS build
COPY . /app/
COPY --from=dev /app/node_modules /app/node_modules
WORKDIR /app
RUN npm run build

FROM node:20-alpine
COPY ./package.json package-lock.json /app/
COPY --from=prod /app/node_modules /app/node_modules
COPY --from=build /app/build /app/build
WORKDIR /app
CMD ["npm", "run", "start"]