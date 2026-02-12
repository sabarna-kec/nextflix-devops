# Stage 3: Runner (Production)
FROM node:16-alpine AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

# Create a non-root user for security
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy necessary files from builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Set correct permissions
RUN chown -R nextjs:nodejs /app

# Switch to non-root user
USER nextjs

# Expose the port Next.js runs on
EXPOSE 3000

ENV PORT 3000

# Environment variables (can be overridden at runtime)
# ENV NEXT_PUBLIC_TMDB_API_KEY=your_api_key_here
# ENV NEXT_PUBLIC_TMDB_BASE_URL=https://api.themoviedb.org/3
# ENV NEXT_PUBLIC_IMAGE_BASE_URL=https://image.tmdb.org/t/p/original

# Start the application
CMD ["node", "server.js"]
