# Auto-Tax Smart Contract

The **Auto-Tax** smart contract is an ERC-20 token extension that implements an automatic tax deduction mechanism on token transfers. It enables decentralized projects to allocate a percentage of every transaction as tax, which is sent to a treasury address for funding development, liquidity, or other purposes.

---

## 🚀 Features

- 💸 **Automatic Tax Deduction** — A configurable tax rate deducted on each token transfer.
- 🎯 **Treasury Fund Collection** — Tax amounts are forwarded to a designated treasury wallet.
- 🔧 **Owner-Controlled Tax Rate** — Tax rate adjustable by contract owner within safe limits.
- 🚫 **Tax Exemptions** — Owner and treasury addresses exempt from tax to avoid recursion.
- 🔐 **Secure Access Control** — Only owner can modify tax settings.
- 📊 **Events Emitted** — Real-time tracking of tax rate updates and tax transfers.

---

## 📦 Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/yourusername/auto-tax.git
cd auto-tax
npm install
🛠️ Usage
Deploy Contract
Use Hardhat or your preferred tool:

bash
Copy
Edit
npx hardhat run scripts/deploy.js --network <network-name>
Set Tax Rate (Owner Only)
solidity
Copy
Edit
autoTaxContract.setTaxRate(newTaxRate);
Note: Tax rate is specified in basis points (e.g., 250 = 2.5%).

🔍 Example
solidity
Copy
Edit
// Transfer 100 tokens from sender to recipient
token.transfer(recipient, 100 * 10**18);

// Automatically deducts tax and sends it to treasury
✅ Tests
Run tests to verify functionality:

bash
Copy
Edit
npx hardhat test
Tests cover:

Tax deduction correctness on transfers

Owner's ability to update tax rate

Tax exemptions for owner and treasury

Correct forwarding of tax to treasury

📁 File Structure
bash
Copy
Edit
contracts/
├── AutoTax.sol           # Core auto-tax smart contract
scripts/
├── deploy.js             # Deployment script
test/
├── autoTax.test.js       # Unit tests
