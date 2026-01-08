# Project1 Build Guide

## Technology Stack
- React 19.2.0
- TypeScript 5.9.3
- Vite 7.2.4

## Prerequisites
- Node.js 20.x or higher
- npm 10.x or higher

## Build Commands

### Install Dependencies
```bash
npm install
# or
npm ci  # for CI/CD environments
```

### Development Server
```bash
npm run dev
```
Opens at `http://localhost:9801`

### Production Build
```bash
npm run build
```

### Build Output
- Location: `dist/`
- Files:
  - `dist/index.html` - Main HTML file
  - `dist/assets/` - JavaScript, CSS, and image assets

## Expected Build Output

### Success Indicators
```
> project1@0.0.0 build
> vite build

vite v7.3.1 building client environment for production...
transforming...
✓ 32 modules transformed.
rendering chunks...
computing gzip size...
dist/index.html                   0.46 kB │ gzip:  0.29 kB
dist/assets/react-CHdo91hT.svg    4.13 kB │ gzip:  2.05 kB
dist/assets/index-COcDBgFa.css    1.38 kB │ gzip:  0.70 kB
dist/assets/index-BWMuc5b_.js   193.91 kB │ gzip: 60.94 kB
✓ built in 693ms
```

### Exit Code
- **Success**: `0`
- **Failure**: Non-zero

## CI/CD Integration

### GitHub Actions
Workflow file: `.github/workflows/project1-build.yml`

Triggers:
- Push to `main` branch with changes in `project1/`
- Pull requests to `main` branch

### Build Steps
1. Checkout code
2. Setup Node.js 20
3. Install dependencies (`npm ci`)
4. Run linter (`npm run lint`)
5. Build project (`npm run build`)
6. Upload artifacts

## Configuration

### Vite Config
File: `vite.config.ts`

Key settings:
- Dev server port: `9801`
- Host: `0.0.0.0` (accessible from all network interfaces)
- Allowed hosts: `testing.albl.cloud`, `localhost`

## Troubleshooting

### Build Fails
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Port Already in Use
```bash
# Change port in vite.config.ts
server: {
  port: 9802  # Use different port
}
```

### Dependencies Issues
```bash
# Update dependencies
npm update
npm run build
```
