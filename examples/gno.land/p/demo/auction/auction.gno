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
	Begin       time.Time
	End         time.Time
	Price       uint64
	Bids        []*Bid
	State       string // "upcoming", "ongoing", or "closed"
}

// Bid struct
type Bid struct {
	Bidder std.Address
	Amount uint64
}

var (
	auctionList []*Auction
	currentTime time.Time
)

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
		Begin:       begin,
		End:         end,
		Price:       minPrice,
		Bids:        []*Bid{},
		State:       "upcoming",
	}
}

// AddBid adds a new bid to the auction
func (a *Auction) AddBid(bidder std.Address, amount uint64) {
	if now().Before(a.Begin) {
		panic("Auction has not started yet")
	}
	if now().After(a.End) {
		panic("Auction has already ended")
	}
	if amount <= a.Price {
		panic("Bid amount must be higher than the current highest bid")
	}
	bid := &Bid{Bidder: bidder, Amount: amount}
	a.Bids = append(a.Bids, bid)
	a.Price = amount
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
	if now().Before(a.End) {
		panic("Auction cannot end before the end time")
	}
	if a.State == "closed" {
		panic("Auction is already closed")
	}
	a.State = "closed"
	if len(a.Bids) == 0 {
		std.Emit("AuctionEndedNoBids", "auction", a.Title)
		return
	}
	highestBid := a.Price
	winner := a.Bids[len(a.Bids)-1].Bidder
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
