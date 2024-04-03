package Auction 
import (
    "std"
	"time"
	"gno.land/p/demo/grc/grc721"
    "gno.land/p/demo/avl"
)
// Main struct
type Auction struct {
	lot []Lot
	bidder []User
	titeAuciton string
	description string
	deadline time.Time 
	minPrice int64 
}
type User struct {
	bidder std.Address
	amount int64
}
type Lot struct {
	title string
	description strings
	item grc721.basicNFT
}
// Auction instance constructor
func NewAuction(title string, description string, deadline time.Time, minPrice int64) *Auction {
	return &Auction{
		titleAuction: title,
		description: description,
		deadline: deadline,
		minPrice: minPrice,
	}
}
func (a *Auction) AddLot(title string, description string, item grc721.basicNFT) {
	a.lot = append(a.lot, Lot{
		title: title,
		description: description,
		item: item,
	})
}
func (a *Auction) Bid(bidder std.Address, amount int64) {
	if amount < a.minPrice {
		return
	}
	a.bidder = append(a.bidder, User{
		bidder: bidder,
		amount: amount,
	})
}
// func (a *Auction) Close() {
// 	if time.Now().After(a.deadline) {
// 		// Sort bidders by amount
// 		avl.Sort(a.bidder, func(i, j int) bool {
// 			return a.bidder[i].amount > a.bidder[j].amount
// 		})
// 		// Transfer item to the highest bidder
// 		if len(a.bidder) > 0 {
// 			// Transfer item to the highest bidder
// 			a.lot[0].item.Transfer(a.bidder[0].bidder)
// 		}
// 	}
// }
