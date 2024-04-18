package auction

import (
	"std"
	"strconv"
	"time"

	auctionp "gno.land/p/demo/auction"
	"gno.land/p/demo/avl"
)

var (
	auctionTree *avl.tree
	UserTree    *avl.tree
)

// constructor of auction
func init() {
	auctionTree = avl.NewTree()
}

func NewUser(name string) string {
	address := std.GetOrigCaller()
	// check if user already exists
	if _, ok := UserTree.Get(address.String()); ok {
		panic("user already exists")
	}

	// create a user instance
	user := auctionp.NewUser(name, address)
	// add user to usertree
	UserTree.Set(address.String(), user)
	return "user created"
}

func NewAuction(title string, owner std.Address, description string, begin time.Time, deadline time.Time, minPrice uint64) string {
	// get the original caller

	txSender := std.GetOrigCaller()
	// check if deadline is in the future
	if begin <= time.Now().Unix() {
		panic("begin has to be in the future")
	}
	// check if begin auction is in the future
	if deadline <= time.Now().Unix() {
		panic("deadline has to be in the future")
	}
	// check if deadline is after begin
	if deadline <= begin {
		panic("deadline has to be after begin")
	}
	// check if minimum price is a valid value
	if minPrice <= 0 {
		panic("minPrice has to be positive")
	}

	// create an auction instance
	auc := auctionp.NewAuction(title, txSender, description, begin, deadline, minPrice)
	// Update AVL tree with new state
	id := strconv.Itoa(auctionTree.Size())
	auctionTree.Set(id, auc)
	return "auction created"
}

func AddBid(auctionID string, price uint64) string {
	// get the original caller
	bidder := std.GetOrigCaller()
	// get the auction
	auction, ok := auctionTree.Get(auctionID)
	// check if auction exists
	if !ok {
		panic("auction does not exist")
	}
	auction = auction.(*auctionp.Auction)
	// check if auction is open
	if auction.GetBegin() > time.Now().Unix() {
		panic("auction is not open yet")
	}
	// check if auction is still open
	if auction.GetDeadline() <= time.Now().Unix() {
		panic("auction is closed")
	}

	// check if price is higher than minimum price
	if auction.GetPrice() >= price {
		panic("price has to be higher than minimum price")
	}
	if auction.IsOwner(bidder) {
		panic("owner cannot bid")
	}
	// create a bid instance
	bid := auctionp.NewBid(bidder, price)
	auction.AddBid(bid)
	return "bid placed"
}

func Render() string {
	return "ok"
}
