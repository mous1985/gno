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
	txSender := std.GetOrigCaller()
	if begin <= time.Now().Unix() {
		panic("deadline has to be in the future")
	}
	if deadline <= time.Now().Unix() {
		panic("deadline has to be in the future")
	}
	if deadline <= begin {
		panic("deadline has to be after begin")
	}
	
	if minPrice <= 0 {
		panic("minPrice has to be positive")
	}
	id:=strconv.Itoa(auctionTree.Size())
	auc := auction.NewAuction(title, txSender, description, begin, deadline, minPrice)
	auctionID.Next()
	auctionTree.Set(id, auc)
	return "auction created "
}

func Render() string {
}
