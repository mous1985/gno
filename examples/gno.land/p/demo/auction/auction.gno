package auction

import (
	"std"
	"strconv"

	"gno.land/p/demo/avl"
)

// Main struct
type Auction struct {
	titleAuction string
	owner        *User
	description  string
	bids         *avl.Tree // key: std.Address, value: Bid
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
	titleAuction string,
	owner *User,
	description string,
) *Auction {
	return &Auction{
		titleAuction: titleAuction,
		description:  description,
		owner:        owner,
		bids:         avl.NewTree(),
	}
}

func NewUser(name string, address std.Address) *User {
	return &User{
		name:    name,
		address: address,
	}
}

func (U User) GetName() string {
	return U.name
}

func (U User) GetAddress() std.Address {
	return U.address
}

func (A Auction) GetTitle() string {
	return A.titleAuction
}

func (A Auction) GetDescription() string {
	return A.description
}

func (A Auction) GetOwner() *User {
	return A.owner
}

func (A Auction) isOwner() bool {
	return std.GetOrigCaller() == A.owner.address
}

func (A Auction) AddBid(key int, bidder *User, amount uint64) {
	bid := &Bid{
		bidder: bidder,
		amount: amount,
	}
	A.bids.Set(strconv.Itoa(key), bid)
}
