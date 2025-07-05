#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Setting up Edit Messages Challenge 1: Fix Unclear Commit Messages${NC}"

# Clean up any existing workspace
rm -rf workspace

# Create workspace directory and initialize git repository there
mkdir -p workspace
cd workspace
git init

# Set up git user for this challenge
git config user.name "Git Drills Student"
git config user.email "student@git-drills.local"

# Create initial project structure
mkdir -p src tests docs

# Create initial files
cat > src/app.js << 'EOF'
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('Hello World!');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

module.exports = app;
EOF

cat > package.json << 'EOF'
{
  "name": "sample-app",
  "version": "1.0.0",
  "description": "Sample application for Git Drills",
  "main": "src/app.js",
  "scripts": {
    "start": "node src/app.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "jest": "^29.0.0"
  }
}
EOF

cat > README.md << 'EOF'
# Sample App

A simple Express.js application for Git Drills practice.

## Getting Started

```bash
npm install
npm start
```

## Testing

```bash
npm test
```
EOF

# Create initial commit
git add .
git commit -m "Initial project setup"

# Create messy commits with unclear messages
echo "app.use(express.json());" >> src/app.js
git add src/app.js
git commit -m "fix stuff"

# Add authentication middleware
cat >> src/app.js << 'EOF'

// Authentication middleware
const auth = (req, res, next) => {
    const token = req.header('Authorization');
    if (!token) {
        return res.status(401).json({ error: 'No token provided' });
    }
    next();
};

app.use('/api', auth);
EOF

git add src/app.js
git commit -m "update code"

# Add API endpoints
cat >> src/app.js << 'EOF'

app.get('/api/users', (req, res) => {
    res.json({ users: [] });
});

app.post('/api/users', (req, res) => {
    res.json({ message: 'User created' });
});
EOF

git add src/app.js
git commit -m "changes"

# Add error handling
cat >> src/app.js << 'EOF'

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something went wrong!');
});
EOF

git add src/app.js
git commit -m "more stuff"

# Add tests
cat > tests/app.test.js << 'EOF'
const request = require('supertest');
const app = require('../src/app');

describe('API Tests', () => {
    test('GET / should return Hello World', async () => {
        const response = await request(app).get('/');
        expect(response.text).toBe('Hello World!');
    });

    test('GET /api/users should require authentication', async () => {
        const response = await request(app).get('/api/users');
        expect(response.status).toBe(401);
    });
});
EOF

git add tests/
git commit -m "add some tests"

echo -e "${GREEN}✅ Setup complete! You now have a repository with unclear commit messages.${NC}"
echo -e "${BLUE}📋 Current commit history:${NC}"
git log --oneline
echo ""
echo -e "${BLUE}🎯 Your goal: Use 'git rebase -i' to improve these commit messages!${NC}"