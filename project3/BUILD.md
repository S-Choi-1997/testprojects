# Project3 Build Guide

## Technology Stack
- Node.js 20.19.6
- Express 4.18.2

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

### Build Project
```bash
npm run build
```

Currently this runs a simple build script. For production, you might want to add:
- TypeScript compilation
- Code bundling
- Environment variable validation

### Run Application
```bash
npm start
```

### Development Mode (with auto-reload)
```bash
# Install nodemon (if not already)
npm install --save-dev nodemon

# Add to package.json scripts:
# "dev": "nodemon src/index.js"

npm run dev
```

## Build Output

### Success Indicators
```
> project3@1.0.0 build
> echo 'Build successful'

Build successful
```

### Exit Code
- **Success**: `0`
- **Failure**: Non-zero

## Application Endpoints

### Available Routes
- `GET /api/express` - Returns welcome message
- `GET /api/express/health` - Health check endpoint

### Example Responses

#### Main Endpoint
```bash
curl http://localhost:3000/api/express
```
Response:
```json
{
  "message": "Hello from Express!"
}
```

#### Health Check
```bash
curl http://localhost:3000/api/express/health
```
Response:
```json
{
  "status": "ok"
}
```

## CI/CD Integration

### GitHub Actions
Workflow file: `.github/workflows/project3-build.yml`

Triggers:
- Push to `main` branch with changes in `project3/`
- Pull requests to `main` branch

### Build Steps
1. Checkout code
2. Setup Node.js 20
3. Install dependencies (`npm ci`)
4. Run build script (`npm run build`)
5. Test application startup
6. Test API endpoints

## Configuration

### Server Configuration
File: `src/index.js`

```javascript
const port = 3000;
app.listen(port, '0.0.0.0', () => {
  console.log(`Server running at http://0.0.0.0:${port}`);
});
```

- Port: `3000`
- Host: `0.0.0.0` (accessible from all network interfaces)

## Troubleshooting

### Port Already in Use
```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>

# Or change port in src/index.js
const port = 3001;
```

### Module Not Found
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### Dependencies Issues
```bash
# Update dependencies
npm update

# Check for vulnerabilities
npm audit
npm audit fix
```

## Production Deployment

### Environment Variables
Create a `.env` file (not committed to git):
```env
NODE_ENV=production
PORT=3000
```

Load with dotenv:
```javascript
require('dotenv').config();
const port = process.env.PORT || 3000;
```

### Process Manager (PM2)
```bash
# Install PM2
npm install -g pm2

# Start application
pm2 start src/index.js --name "project3"

# Monitor
pm2 monit

# Logs
pm2 logs project3

# Restart
pm2 restart project3

# Stop
pm2 stop project3
```

### Docker Deployment
Application is included in main Docker setup:
```bash
# From project root
docker-compose up -d
```

## Development Enhancements

### Add TypeScript Support
```bash
npm install --save-dev typescript @types/node @types/express ts-node

# Create tsconfig.json
npx tsc --init

# Update package.json
"scripts": {
  "build": "tsc",
  "start": "node dist/index.js",
  "dev": "ts-node src/index.ts"
}
```

### Add Linting
```bash
npm install --save-dev eslint

# Initialize ESLint
npx eslint --init

# Add to package.json
"scripts": {
  "lint": "eslint src/**/*.js"
}
```

### Add Testing
```bash
npm install --save-dev jest supertest

# Add to package.json
"scripts": {
  "test": "jest"
}
```

## Performance Tips

### Enable Compression
```javascript
const compression = require('compression');
app.use(compression());
```

### Enable CORS (if needed)
```javascript
const cors = require('cors');
app.use(cors());
```

### Request Logging
```javascript
const morgan = require('morgan');
app.use(morgan('combined'));
```
