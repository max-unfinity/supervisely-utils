# Base
FROM node:20-bookworm-slim

# System dependencies for Playwright + general tooling
RUN apt-get update && apt-get install -y \
    # Playwright browser dependencies
    libglib2.0-0 libnss3 libdbus-1-3 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 \
    libxrandr2 libgbm1 libasound2 libpango-1.0-0 libcairo2 libx11-xcb1 \
    # Fonts — critical for Cyrillic rendering
    fonts-liberation fonts-noto fonts-noto-cjk \
    # Python stack
    python3 python3-pip python3-venv \
    # Utilities
    curl wget git jq ca-certificates gnupg unzip \
    # For stealth / headers debugging
    procps htop \
    && rm -rf /var/lib/apt/lists/*

# Python packages
RUN pip3 install --break-system-packages \
    playwright \
    httpx \
    beautifulsoup4 \
    lxml \
    pandas \
    Pillow \
    fake-useragent \
    python-dotenv

# Node packages (global)
RUN npm install -g --force \
    playwright \
    @playwright/mcp \
    playwright-extra \
    puppeteer-extra-plugin-stealth

# Environment defaults (set before browser installs so paths are consistent)
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV NODE_ENV=production
ENV PYTHONUNBUFFERED=1

# Install Playwright browsers
# Install all three; agent picks based on marketplace behavior
RUN npx playwright install chromium firefox webkit
RUN npx playwright install-deps

# Python Playwright browsers
RUN python3 -m playwright install chromium

# Claude Code CLI
RUN curl -fsSL https://claude.ai/install.sh | bash

# Working directory & skills
WORKDIR /app

# Pre-copy skills so they're available without network
# COPY skills/ /app/skills/
# COPY scripts/ /app/scripts/

# Create output directories
RUN mkdir -p /app/output/reports /app/output/screenshots /app/output/data

# MCP server config for Claude Code
# COPY .claude/ /root/.claude/

# Entrypoint
# Default: drop into Claude Code CLI
# Override with: docker run ... node scrape_kaspi.js "query"
# CMD ["claude"]
