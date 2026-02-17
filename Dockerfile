FROM node:18-alpine as builder
WORKDIR /app
COPY . .
RUN npm install --include=dev
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/.next/standalone .
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static

ENV PORT=3000
EXPOSE $PORT
CMD ["sh", "-c", "PORT=${PORT} node server.js"]