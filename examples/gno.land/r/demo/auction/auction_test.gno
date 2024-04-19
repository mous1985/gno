package auction

// import (
// 	"std"
// 	"testing"
// 	"time"

// 	"gno.land/p/demo/testutils"
// )

// var (
// 	auct *auction.Auction
// 	user *auction.User
// )

// func TestNewUser(t *testing.T) {
// 	name := "user1"
// }

// func TestNewAuction(t *testing.T) {
// 	title := "Auction 1"
// 	owner := std.Address{}
// 	description := "This is an auction"
// 	begin := time.Now().Add(time.Hour)
// 	deadline := time.Now().Add(2 * time.Hour)
// 	minPrice := uint64(100)
// 	expected := "auction created"

// 	result := NewAuction(title, owner, description, begin, deadline, minPrice)

// 	assert.Equal(t, expected, result)
// }

// func TestAddBid(t *testing.T) {
// 	auctionID := "1"
// 	price := uint64(200)
// 	expected := "bid placed"

// 	result := AddBid(auctionID, price)

// 	assert.Equal(t, expected, result)
// }

// func TestRender(t *testing.T) {
// 	expected := "ok"

// 	result := Render()

// 	assert.Equal(t, expected, result)
// }
