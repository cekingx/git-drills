#!/bin/bash
set -euo pipefail

# Interactive Rebase Problem 1: Clean up a feature branch
# Creates a messy commit history that needs cleaning

echo "Setting up Interactive Rebase Problem 1..."

# Initialize git repository
git init
git config user.name "Git Drills Student"
git config user.email "student@git-drills.local"

# Create initial project structure
mkdir -p src tests docs
echo "# My Project" > README.md
echo "console.log('Hello, World!');" > src/main.js
echo "// Test file" > tests/test.js
echo "# Documentation" > docs/README.md

# Create initial commit
git add .
git commit -m "Initial project setup"

# Create feature branch
git checkout -b feature/user-authentication

# Create a messy history with various types of commits
echo "class User {" > src/user.js
echo "  constructor(name) {" >> src/user.js
echo "    this.name = name;" >> src/user.js
echo "  }" >> src/user.js
echo "}" >> src/user.js
git add src/user.js
git commit -m "Add user class"

# Add some debug/WIP commits
echo "console.log('DEBUG: User created');" >> src/user.js
git add src/user.js
git commit -m "debug: add debug logging"

echo "  authenticate(password) {" >> src/user.js
echo "    return password === 'secret';" >> src/user.js
echo "  }" >> src/user.js
git add src/user.js
git commit -m "WIP: add auth method"

# Fix typo commit
sed -i 's/secret/secretpassword/g' src/user.js
git add src/user.js
git commit -m "fix typo in password"

# Add test file
echo "const User = require('./src/user');" > tests/user.test.js
echo "const user = new User('Alice');" >> tests/user.test.js
echo "console.log(user.authenticate('secretpassword'));" >> tests/user.test.js
git add tests/user.test.js
git commit -m "Add user tests"

# Another debug commit
echo "console.log('DEBUG: Running tests');" >> tests/user.test.js
git add tests/user.test.js
git commit -m "debug: add test logging"

# Update documentation
echo "## User Authentication" >> docs/README.md
echo "The User class provides basic authentication functionality." >> docs/README.md
git add docs/README.md
git commit -m "Update documentation"

# Remove debug code
sed -i '/console.log.*DEBUG/d' src/user.js
sed -i '/console.log.*DEBUG/d' tests/user.test.js
git add src/user.js tests/user.test.js
git commit -m "Remove debug code"

echo "Setup complete!"
echo "Current git log:"
git log --oneline
echo ""
echo "Challenge: Use interactive rebase to clean up this messy history"
echo "Goal: Combine related commits and create a clean, logical history"