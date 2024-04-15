package auction

import (
	"std"
	"time"
	"strconv"
	"gno.land/p/demo/auction"
	"gno.land/p/demo/avl"
	"gno.land/p/demo/seqid"
)

var (
	auctionTree *avl.tree
	auctionID   seqid.ID
)

// constructor of auction
func init() {
	auctionTree = avl.NewTree()
}

func NewAuction(title string, description string, begin time.Time, deadline time.Time, minPrice) string {
	// get the original caller
	txSender := std.GetOrigCaller()
	//check if deadline is in the past 
	if begin <= time.Now().Unix() {
		panic("deadline has to be in the past")
	}
	//check if begin auction is in the past
	if deadline <= time.Now().Unix() {
		panic("deadline has to be in the past")
	}
	//check if deadline is after begin
	if deadline <= begin {
		panic("deadline has to be after begin")
	}
	//check if minimum price is a valid value  
	if minPrice <= 0 {
		panic("minPrice has to be positive")
	}
	
	// create an auction instance
	auc := auction.NewAuction(title, txSender, description, begin, deadline, minPrice)
	// Update AVL tree with new state
	id:=strconv.Itoa(auctionTree.Size())
	auctionID.Next()
	auctionTree.Set(id, auc)
	return "auction created"
}

func Render() string {
}
