# Etapa de build
FROM node:20-alpine AS builder

WORKDIR /app

# Copia os arquivos necessários
COPY package*.json ./
RUN npm install --omit=dev

COPY . .
RUN npm run build

# Etapa de runtime
FROM node:20-alpine

ENV NODE_ENV=production
WORKDIR /app

# Copia build e dependências da etapa anterior
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Porta que a Evolution escuta
EXPOSE 8080

# Comando de inicialização
CMD ["node", "dist/main.js"]
