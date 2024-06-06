package auction

import (
	"std"
	"strconv"
	"time"
)

// Auction struct
type Auction struct {
	Title       string
	Owner       std.Address
	Description string
	begin       time.Time
	end         time.Time
	price       uint64
	bids        []*Bid
	State       string // "open" or "closed"
}

// Bid struct
type Bid struct {
	Bidder std.Address
	Amount uint64
}

var currentTime time.Time

// NewAuction creates a new auction
func NewAuction(
	title string,
	owner std.Address,
	description string,
	begin time.Time,
	end time.Time,
	minPrice uint64,
) *Auction {
	return &Auction{
		Title:       title,
		Description: description,
		Owner:       owner,
		begin:       begin,
		end:         end,
		price:       minPrice,
		bids:        []*Bid{},
		State:       "open",
	}
}

// Getter methods for private fields
func (a *Auction) GetBegin() time.Time {
	return a.begin
}

func (a *Auction) GetEnd() time.Time {
	return a.end
}

func (a *Auction) GetPrice() uint64 {
	return a.price
}

func (a *Auction) GetBids() []*Bid {
	return a.bids
}

// Setter methods for the owner to modify fields
func (a *Auction) SetTitle(caller std.Address, title string) {
	if caller != a.Owner {
		panic("Only the owner can modify the title")
	}
	a.Title = title
}

func (a *Auction) SetDescription(caller std.Address, description string) {
	if caller != a.Owner {
		panic("Only the owner can modify the description")
	}
	a.Description = description
}

// AddBid adds a new bid to the auction
func (a *Auction) AddBid(bidder std.Address, amount uint64) {
	if now().Before(a.begin) {
		panic("Auction has not started yet")
	}
	if now().After(a.end) {
		panic("Auction has already ended")
	}
	if amount <= a.price {
		panic("Bid amount must be higher than the current highest bid")
	}
	bid := &Bid{Bidder: bidder, Amount: amount}
	a.bids = append(a.bids, bid)
	a.price = amount
	std.Emit("BidPlaced", "auction", a.Title, "bidder", bidder.String(), "amount", strconv.FormatUint(amount, 10))
}

// IsOwnedBy checks if the given address is the owner of the auction
func (a *Auction) IsOwnedBy(address std.Address) bool {
	return a.Owner == address
}

// EndAuction ends the auction
func (a *Auction) EndAuction(caller std.Address) {
	if caller != a.Owner {
		panic("Only the owner can end the auction")
	}
	if now().Before(a.end) {
		panic("Auction cannot end before the end time")
	}
	if a.State == "closed" {
		panic("Auction is already closed")
	}
	a.State = "closed"
	if len(a.bids) == 0 {
		std.Emit("AuctionEndedNoBids", "auction", a.Title)
		return
	}
	highestBid := a.price
	winner := a.bids[len(a.bids)-1].Bidder
	std.Emit("AuctionEnded", "winner", winner.String(), "amount", strconv.FormatUint(highestBid, 10))
}

// SetCurrentTime sets the current time for testing purposes
func SetCurrentTime(t time.Time) {
	currentTime = t
}

// now returns the current time, allowing for mocking in tests
func now() time.Time {
	if !currentTime.IsZero() {
		return currentTime
	}
	return time.Now()
}
