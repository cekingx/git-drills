#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Setting up Edit Messages Challenge 2: Apply Conventional Commit Standards${NC}"

# Clean up any existing workspace
rm -rf workspace

# Create workspace directory and initialize git repository there
mkdir -p workspace
cd workspace
git init

# Set up git user for this challenge
git config user.name "Git Drills Student"
git config user.email "student@git-drills.local"

# Create initial project structure for an open source library
mkdir -p src lib docs examples

# Create initial library files
cat > src/calculator.js << 'EOF'
/**
 * A simple calculator library
 */
class Calculator {
    add(a, b) {
        return a + b;
    }

    subtract(a, b) {
        return a - b;
    }

    multiply(a, b) {
        return a * b;
    }

    divide(a, b) {
        if (b === 0) {
            throw new Error('Division by zero');
        }
        return a / b;
    }
}

module.exports = Calculator;
EOF

cat > package.json << 'EOF'
{
  "name": "awesome-calculator",
  "version": "1.0.0",
  "description": "A simple calculator library for Node.js",
  "main": "lib/calculator.js",
  "scripts": {
    "build": "babel src --out-dir lib",
    "test": "jest",
    "docs": "jsdoc src/*.js -d docs"
  },
  "keywords": ["calculator", "math", "utility"],
  "author": "Git Drills Student",
  "license": "MIT",
  "devDependencies": {
    "@babel/cli": "^7.0.0",
    "@babel/core": "^7.0.0",
    "@babel/preset-env": "^7.0.0",
    "jest": "^29.0.0",
    "jsdoc": "^4.0.0"
  }
}
EOF

cat > README.md << 'EOF'
# Awesome Calculator

A simple calculator library for Node.js.

## Installation

```bash
npm install awesome-calculator
```

## Usage

```javascript
const Calculator = require('awesome-calculator');

const calc = new Calculator();
console.log(calc.add(2, 3)); // 5
```

## Contributing

Please read our contributing guidelines before submitting pull requests.
EOF

cat > .gitignore << 'EOF'
node_modules/
lib/
coverage/
*.log
EOF

# Create initial commit
git add .
git commit -m "Initial library setup"

# Create commits with informal messages that need conventional formatting
echo "power(base, exponent) { return Math.pow(base, exponent); }" >> src/calculator.js
git add src/calculator.js
git commit -m "added power function"

# Add build configuration
cat > .babelrc << 'EOF'
{
  "presets": ["@babel/preset-env"]
}
EOF

git add .babelrc
git commit -m "build configuration"

# Fix a bug in division
sed -i 's/Division by zero/Cannot divide by zero/g' src/calculator.js
git add src/calculator.js
git commit -m "fixed error message"

# Add tests
cat > src/calculator.test.js << 'EOF'
const Calculator = require('./calculator');

describe('Calculator', () => {
    let calc;

    beforeEach(() => {
        calc = new Calculator();
    });

    test('should add two numbers', () => {
        expect(calc.add(2, 3)).toBe(5);
    });

    test('should subtract two numbers', () => {
        expect(calc.subtract(5, 3)).toBe(2);
    });

    test('should multiply two numbers', () => {
        expect(calc.multiply(4, 3)).toBe(12);
    });

    test('should divide two numbers', () => {
        expect(calc.divide(10, 2)).toBe(5);
    });

    test('should throw error when dividing by zero', () => {
        expect(() => calc.divide(10, 0)).toThrow('Cannot divide by zero');
    });

    test('should calculate power', () => {
        expect(calc.power(2, 3)).toBe(8);
    });
});
EOF

git add src/calculator.test.js
git commit -m "unit tests for calculator"

# Update documentation
cat > docs/API.md << 'EOF'
# API Documentation

## Calculator Class

### Methods

- `add(a, b)` - Adds two numbers
- `subtract(a, b)` - Subtracts b from a
- `multiply(a, b)` - Multiplies two numbers
- `divide(a, b)` - Divides a by b
- `power(base, exponent)` - Calculates base to the power of exponent

### Error Handling

- `divide()` throws an error when dividing by zero
EOF

git add docs/
git commit -m "documentation update"

# Add contributing guidelines
cat > CONTRIBUTING.md << 'EOF'
# Contributing to Awesome Calculator

Thank you for your interest in contributing!

## Development Setup

1. Fork the repository
2. Clone your fork
3. Install dependencies: `npm install`
4. Make your changes
5. Run tests: `npm test`
6. Submit a pull request

## Commit Message Format

Please use conventional commits:
- feat: new features
- fix: bug fixes
- docs: documentation changes
- test: adding tests
- build: build system changes
EOF

git add CONTRIBUTING.md
git commit -m "contributing guidelines"

echo -e "${GREEN}✅ Setup complete! You now have a repository with informal commit messages.${NC}"
echo -e "${BLUE}📋 Current commit history:${NC}"
git log --oneline
echo ""
echo -e "${BLUE}🎯 Your goal: Convert these to conventional commit format!${NC}"
echo -e "${BLUE}📖 Conventional format: type(scope): description${NC}"
echo -e "${BLUE}   Types: feat, fix, docs, test, build, refactor, style, ci, chore${NC}"