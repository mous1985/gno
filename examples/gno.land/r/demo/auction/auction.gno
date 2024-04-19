package auction

import (
	"bytes"
	"std"
	"strconv"
	"time"

	auctionp "gno.land/p/demo/auction"
	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
)

var (
	auctionTree *avl.Tree
	UserTree    *avl.Tree
)

// constructor of auction
func init() {
	auctionTree = avl.NewTree()
	UserTree = avl.NewTree()
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

func NewAuction(
	title string,
	description string,
	begin int64,
	deadline int64,
	minPrice uint64,
) string {
	// get the original caller

	txSender := std.GetOrigCaller()

	// check if begin auction is in the future
	if begin <= time.Now().Unix() {
		panic("begin has to be in the future")
	}
	// check if deadline is in the future
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
	owner, _ := UserTree.Get(txSender.String()).(*auctionp.User)

	// create an auction instance
	auc := auctionp.NewAuction(
		title,
		owner,
		description,
		time.Unix(begin, 0),
		time.Unix(deadline, 0),
		minPrice,
	)
	// Update AVL tree with new state
	id := strconv.Itoa(auctionTree.Size())
	auctionTree.Set(id, auc)
	return "auction created"
}

func AddBid(auctionID string, price uint64) string {
	// get the original caller
	bidder := std.GetOrigCaller()
	// get the auction
	auc, ok := auctionTree.Get(auctionID)
	// check if auction exists
	if !ok {
		panic("auction does not exist")
	}
	auction := auc.(*auctionp.Auction)
	// check if auction is open
	if auction.GetBegin() <= time.Now() {
		panic("auction is not open yet")
	}
	if auction.IsOwner() {
		panic("owner cannot bid")
	}
	// check if auction is still open
	if auction.GetDeadline() <= time.Now() {
		panic("auction is closed")
	}

	// check if price is higher than minimum price
	if auction.GetPrice() >= price {
		panic("price has to be higher than minimum price")
	}

	// create a bid instance
	user := UserTree.Get(bidder.String()).(*auctionp.User)
	auction.AddBid(user, price)
	return "bid placed"
}

func Render(path string) string {
	if path == "" {
		return renderHomepage()
	}
	return "unkown page"
}

func renderHomepage() string {
	var b bytes.Buffer
	b.WriteString("## Auctions\n\n")
	if auctionTree.Size() == 0 {
		b.WriteString("## No auctions available\n")
		return b.String()
	}
	auctionTree.Iterate("", "", func(key string, value interface{}) bool {
		auc := value.(*auctionp.Auction)
		b.WriteString("#### Auction: " + auc.GetTitle() + "\n\n")
		b.WriteString("## Owner: " + auc.GetOwner().GetName() + "\n")
		b.WriteString("Description: " + auc.GetDescription() + "\n")
		b.WriteString("Begin: " + auc.GetBegin().String() + "\n")
		b.WriteString("Deadline: " + auc.GetDeadline().String() + "\n")
		b.WriteString(ufmt.Sprintf("First-Price: %d \n", auc.GetPrice()))
		b.WriteString("## Bids\n")
		return true
	})
	return b.String()
}
