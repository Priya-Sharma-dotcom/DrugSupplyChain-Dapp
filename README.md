# 💉 Drug Supply Chain DApp

A decentralized Ethereum-based drug supply chain management system using smart contracts for secure and transparent tracking of drugs across roles (manufacturer, supplier, distributor, pharmacy, patient).

---

## ✨ Features

* **Role-Based Access Control:** Admin assigns roles to different participants.
* **Drug Registration:** Manufacturers can register new drugs with details.
* **Ownership Transfer:** Drugs can be transferred only to valid next-role participants.
* **Status Updates:** Current owner can update drug delivery status.
* **Ownership History:** Track full chain of ownership.
* **Fully Integrated Frontend:** Built with HTML/JS/Web3.js and connected to MetaMask on Sepolia testnet.

---

## 📁 Project Structure

```
DrugSC/
├── contracts/
│   └── DrugSC.sol               # Smart contract code
├── abi.json                    # ABI of compiled contract
├── index.html                 # Frontend UI
├── web3.js                     # Web3 logic
└── README.md                  # Project documentation
```

---

## ⚙️ Tech Stack

* **Smart Contract:** Solidity (Ethereum Sepolia Testnet)
* **Frontend:** HTML5, CSS3, JavaScript
* **Blockchain Integration:** Web3.js, MetaMask
* **Development Tools:** Remix IDE, MetaMask, Sepolia Faucet

---

## 🌐 How to Use

### ✅ Prerequisites

* MetaMask extension installed and connected to Sepolia Testnet
* Sepolia ETH (from faucet)

### ⚡ Deploy Smart Contract (Already Deployed by)

```
Deployed Address: 0x760391dED47dd19772b23F25B771b75AD0a4E391
```

### ⚡ Smart Contract Address (Deployed at)

```
Contract Address: 0x2feFA95AD589Ebff3883C0d4d821fC65a74A37E0
```

### 🔍 Setup Frontend

1. Clone this repository

```bash
git clone <repo-url>
cd DrugSC
```

2. Open `index.html` in browser
3. Connect MetaMask wallet (ensure Sepolia is selected)

### 👩‍💼 Assign Roles (Admin Only)

* Manufacturer
* Supplier
* Distributor
* Pharmacy
* Patient

### 📅 Register Drug (Manufacturer Only)

* Enter drug name and price

### 📦 Transfer Ownership

* Current owner transfers drug to next eligible role

### ⚖️ Update Status

* Set to `inTransit`, `Delivered`

### 📊 View Info

* Ownership history
* Current owner
* Drug details

---

## 📊 Smart Contract Overview

```solidity
address public admin;                      // Deployer as admin
enum Role { none, manufacturer, supplier, distributor, pharmacy, patient }
enum Status { Created, inTransit, Delivered }

struct Drug {
  string name;
  address manufacturer;
  Status status;
  uint price;
  address currentOwner;
  address[] owners;
}
```

## 👨‍🌾 Role Logic

* **Only Admin**: `assignRoles()`
* **Only Manufacturer**: `RegisterDrug()`
* **Only Current Owner**: `TransferOwnership()` and `UpdateDrugStatus()`

## ✨ Highlights

* Ensures traceability
* Validates role progression
* Prevents unauthorized actions

---

## 📢 License

MIT License

---

## 🌟 Author

Priya Sharma

---

## ✨ Connect

Feel free to contribute or fork the project. For any questions, raise an issue or reach out on LinkedIn!

---

☑️ **Powered by Ethereum | MetaMask | Web3.js**
