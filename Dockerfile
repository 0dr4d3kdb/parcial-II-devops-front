FROM node:20-alpine AS build
ARG VITE_API_VENTAS_URL
ARG VITE_API_DESPACHOS_URL
ENV VITE_API_VENTAS_URL=
ENV VITE_API_DESPACHOS_URL=
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine AS runtime
RUN adduser -D -u 1000 appuser
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
RUN chown -R appuser:appuser /usr/share/nginx/html /var/cache/nginx /var/run
USER appuser
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
