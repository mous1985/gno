# Auction

## Definition of project

The project is an auction system, we have two users, a bidder with his wallet address to bid. The second is the seller, he shares his *NFT* `(grc721)` to sell.
in a first step, i'm developing the functions needed to carry out the transaction .

### Owner

- Must have a wallet .
- Initiate the auction process by listing the item for sale .
- He has the option of accepting or declining the buyer's offer before the end of the countdown.
- He define the starting price.
- He define reserve price (if any)
- He define auction duration(countdow).

### Bidder

- Must have anough of token on his wallet .
- Should be able to view the *NFT* available to auction .
- Must deposit an amount equal to minimum price of the *NFT* in a smart contract as collateral .

### Countdown

 The coutdown is defining by Owner(A special package could be created for the countdown, allowing it to be reused. )

### Logic

The Owner have to put his *NFT* in the smart contact , the same thing for the bidder  .

 ***how smart contarct ensures payment:***

1. **Escrow Mechanism:**
When a bidder places a bid, the bid amount along with the specified percentage of the NFT's value is locked in escrow within the smart contract.
2. **Payment Confirmation:**
Once the auction ends, the winning bidder must confirm the payment within a specified period. If the payment is confirmed, the NFT is transferred to the winning bidder, and the bid amount is released to the seller.
3. **Compensation Mechanism:**
If the winning bidder fails to confirm the payment within the specified period, the seller can claim the percentage of the NFT's value held in escrow as compensation for the failed transaction  
