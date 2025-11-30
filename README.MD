# Decentralized Event Ticketing Smart Contract

A smart contract that enables secure, transparent blockchain-based event ticketing.  
Supports both regular and VIP tickets, refund flows, user ticket data storage, and owner-controlled event management.

---

## Features

### 🎟 Ticket Purchase (Regular + VIP)
- Users can buy regular tickets (0.001 ETH by default).
- Users can buy VIP tickets (0.004 ETH by default).
- Prevents double purchases (one ticket type per user).
- Automatically assigns ticket numbers.
- Stores user details:
  - Name  
  - Email  
  - Phone number  
  - Ticket ID  

### 💸 Refund System
- Refunds available **only before the event date**.
- Regular and VIP refund logic handled independently.
- Updates ticket status on refund.
- Frees seat count for resale.

### 🔐 Owner Controls
- Owner can:
  - Withdraw funds after the event ends.
  - Update ticket prices.
  - Change event date.

### 📊 Tracking & Queries
- View personal ticket info.
- View VIP ticket info.
- Check total tickets sold.
- Check total VIP tickets sold.
- Get seat availability.

---

## Contract Flow

1. **Deploy contract**  
   - Event date set automatically (current timestamp + 7 days)

2. **Users purchase tickets**  
   - `payforticket()` for regular  
   - `Buyvipseats()` for VIP  

3. **Before event date**  
   - Users can call `refund()` or `refundforvip()`  

4. **After event date**  
   - Owner calls `withdraw()` to collect all ETH  

---

## Events

- `PurchasedTicket(buyer, ticketNo, amount)`
- `Refund(user, ticketNo, amount)`
- `Withdraw(owner, amount)`
- `ticketinfo(user, ticketNo)`

---

## Tech Stack

- Solidity ^0.8.0  
- EVM-compatible blockchain  
- Remix / Hardhat for testing  
- OpenZeppelin Ownable for access control  

---

## How to Use

### 1. Install & Deploy
- Clone repo  
- Deploy contract in Remix or Hardhat  

### 2. Buy Ticket
```solidity
payforticket("John", "john@mail.com", 9876543210)

### 3. BuyVip Ticket
```solidity
Buyvipseats("Alice", "alice@mail.com", 9876512345)

### 4. Refund (before event date)
```solidity
refund()
refundforvip()

### 5. Check Ticket Info
```solidity
checkticket()
checkticketvip()

### 6. Owner Withdraw (after event date)
```solidity
withdraw()
