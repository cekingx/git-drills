#!/bin/bash
set -euo pipefail

# Squash Commits Problem 1: Combine WIP commits into atomic commits
# Creates a history with multiple WIP commits that need squashing

echo "Setting up Squash Commits Problem 1..."

# Initialize git repository
git init
git config user.name "Git Drills Student"
git config user.email "student@git-drills.local"

# Create initial project structure
mkdir -p src components styles
echo "# Shopping Cart App" > README.md
echo "<!DOCTYPE html><html><head><title>Shopping Cart</title></head><body></body></html>" > index.html
git add .
git commit -m "Initial project setup"

# Create feature branch
git checkout -b feature/shopping-cart

# Start working on shopping cart feature with multiple WIP commits
echo "class ShoppingCart {" > src/cart.js
echo "  constructor() {" >> src/cart.js
echo "    this.items = [];" >> src/cart.js
echo "  }" >> src/cart.js
git add src/cart.js
git commit -m "WIP: start shopping cart class"

# Add more methods with WIP commits
echo "  addItem(item) {" >> src/cart.js
echo "    this.items.push(item);" >> src/cart.js
echo "  }" >> src/cart.js
git add src/cart.js
git commit -m "WIP: add item method"

echo "  removeItem(id) {" >> src/cart.js
echo "    this.items = this.items.filter(item => item.id !== id);" >> src/cart.js
echo "  }" >> src/cart.js
git add src/cart.js
git commit -m "WIP: remove item method"

echo "  getTotalPrice() {" >> src/cart.js
echo "    return this.items.reduce((total, item) => total + item.price, 0);" >> src/cart.js
echo "  }" >> src/cart.js
echo "}" >> src/cart.js
git add src/cart.js
git commit -m "WIP: add total price calculation"

# Add component with WIP commits
echo "<div class='cart-container'>" > components/cart.html
echo "  <h2>Shopping Cart</h2>" >> components/cart.html
echo "  <div class='cart-items'></div>" >> components/cart.html
git add components/cart.html
git commit -m "WIP: cart component structure"

echo "  <div class='cart-total'>" >> components/cart.html
echo "    <span>Total: $<span id='total'>0.00</span></span>" >> components/cart.html
echo "  </div>" >> components/cart.html
echo "  <button class='checkout-btn'>Checkout</button>" >> components/cart.html
echo "</div>" >> components/cart.html
git add components/cart.html
git commit -m "WIP: add total and checkout button"

# Add styles with WIP commits
echo ".cart-container {" > styles/cart.css
echo "  border: 1px solid #ddd;" >> styles/cart.css
echo "  padding: 20px;" >> styles/cart.css
echo "  margin: 20px;" >> styles/cart.css
git add styles/cart.css
git commit -m "WIP: basic cart styles"

echo "  border-radius: 8px;" >> styles/cart.css
echo "  box-shadow: 0 2px 4px rgba(0,0,0,0.1);" >> styles/cart.css
echo "}" >> styles/cart.css
echo ".cart-items {" >> styles/cart.css
echo "  margin-bottom: 15px;" >> styles/cart.css
echo "}" >> styles/cart.css
git add styles/cart.css
git commit -m "WIP: improve cart styling"

echo ".cart-total {" >> styles/cart.css
echo "  font-weight: bold;" >> styles/cart.css
echo "  font-size: 1.2em;" >> styles/cart.css
echo "  margin-bottom: 15px;" >> styles/cart.css
echo "}" >> styles/cart.css
echo ".checkout-btn {" >> styles/cart.css
echo "  background-color: #007bff;" >> styles/cart.css
echo "  color: white;" >> styles/cart.css
echo "  padding: 10px 20px;" >> styles/cart.css
echo "  border: none;" >> styles/cart.css
echo "  border-radius: 4px;" >> styles/cart.css
echo "  cursor: pointer;" >> styles/cart.css
echo "}" >> styles/cart.css
git add styles/cart.css
git commit -m "WIP: style total and checkout button"

# Add integration
echo "const cart = new ShoppingCart();" > src/main.js
echo "// Initialize cart display" >> src/main.js
echo "document.addEventListener('DOMContentLoaded', function() {" >> src/main.js
echo "  console.log('Shopping cart loaded');" >> src/main.js
echo "});" >> src/main.js
git add src/main.js
git commit -m "WIP: cart integration"

echo "Setup complete!"
echo "Current git log:"
git log --oneline
echo ""
echo "Challenge: Squash WIP commits into logical atomic commits"
echo "Goal: Create 3 clean commits: cart logic, cart UI, and cart integration"