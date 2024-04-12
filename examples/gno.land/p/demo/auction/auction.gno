package auction

import (
	"std"
	"strconv"
	"time"

	"gno.land/p/demo/avl"
)

// Main struct
type Auction struct {
	title       string
	owner       *User
	description string
	begin       time.Time
	deadline    time.Time
	price       uint64
	bids        *avl.Tree // key: std.Address, value: Bid
}

type User struct {
	name    string
	address std.Address
}

type Bid struct {
	bidder *User
	amount uint64
}

func NewAuction(
	title string,
	owner *User,
	description string,
	begin time.Time,
	deadline time.Time,
	minPrice uint64,
) *Auction {
	return &Auction{
		title:       title,
		description: description,
		owner:       owner,
		bids:        avl.NewTree(),
		begin:       begin,
		deadline:    deadline,
		price:       minPrice,
	}
}

func (A Auction) GetTitle() string {
	return A.title
}

func (A Auction) GetDescription() string {
	return A.description
}

func (A Auction) GetOwner() *User {
	return A.owner
}

func (A Auction) GetBegin() time.Time {
	return A.begin
}

func (A Auction) GetDeadline() time.Time {
	return A.deadline
}

func (A Auction) GetMinPrice() uint64 {
	return A.price
}

func (A Auction) GetBids() []*Bid {
	bids := make([]*Bid, 0, A.bids.Size())
	A.bids.Iterate("", "", func(key string, value interface{}) bool {
		bids = append(bids, value.(*Bid))
		return false
	})
	return bids
}

func (A Auction) isOwner() bool {
	return std.GetOrigCaller() == A.owner.address
}

func (A *Auction) AddBid(bidder *User, amount uint64) {
	key := A.bids.Size()
	bid := &Bid{
		bidder: bidder,
		amount: amount,
	}
	A.bids.Set(strconv.Itoa(key), bid)
	A.price = amount
}

// Define a user struct
func NewUser(name string, address std.Address) *User {
	return &User{
		name:    name,
		address: address,
	}
}

// Define a user getter
func (U User) GetName() string {
	return U.name
}

func (U User) GetAddress() std.Address {
	return U.address
}

func NewBid(bidder *User, amount uint64) *Bid {
	return &Bid{
		bidder: bidder,
		amount: amount,
	}
}

func (B Bid) GetBidder() *User {
	return B.bidder
}

func (B Bid) GetAmount() uint64 {
	return B.amount
}
