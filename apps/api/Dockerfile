FROM node:20-alpine AS base
WORKDIR /app
RUN corepack enable

FROM base AS deps
COPY package.json pnpm-workspace.yaml ./
COPY apps/api/package.json ./apps/api/package.json
RUN pnpm install --filter api --frozen-lockfile=false

FROM deps AS build
COPY apps/api ./apps/api
WORKDIR /app/apps/api
RUN pnpm build

FROM base AS runner
WORKDIR /app/apps/api
ENV NODE_ENV=production
COPY --from=build /app/apps/api/dist ./dist
COPY --from=build /app/apps/api/package.json ./package.json
COPY --from=deps /app/node_modules /app/node_modules
EXPOSE 3001
CMD ["node", "dist/main.js"]
