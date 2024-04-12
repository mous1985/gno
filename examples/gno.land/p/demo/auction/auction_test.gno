package auction

import (
	"std"
	"testing"
	"time"

	"gno.land/p/demo/testutils"
) // TestAuction_New verifies that a new Auction
// can be initialized correctly
func TestUser_new(t *testing.T) {
	var (
		name = "user name"
		addr = testutils.TestAddress("user")
	)

	// Create a new User instance
	U := NewUser(name, addr)
	if U.GetName() != name {
		t.Fatalf("invalid name")
	}
	if U.GetAddress() != addr {
		t.Fatalf("invalid address")
	}
}

func TestBid_new(t *testing.T) {
	var (
		amount = uint64(100)
		bidder = testutils.TestAddress("bidder")
		user   = NewUser("bidder", bidder)
	)

	// Create a new Bid instance
	B := NewBid(user, amount)
	if B.GetAmount() != amount {
		t.Fatalf("invalid amount")
	}
	if B.GetBidder() != user {
		t.Fatalf("invalid bidder")
	}
}

func TestAuction_new(t *testing.T) {
	var (
		title       = "auction title"
		user        = testutils.TestAddress("owner")
		owner       = NewUser("owner", user)
		description = "description"
		begin       = time.Now()
		deadline    = begin.Add(time.Hour * 24)
		minPrice    = uint64(1)
	)

	// Create a new Auction instance
	A := NewAuction(title, owner, description, begin, deadline, minPrice)
	if A.GetTitle() != title {
		t.Fatalf("invalid title")
	}
	if A.GetOwner() != owner {
		t.Fatalf("invalid owner")
	}
	if A.GetDescription() != description {
		t.Fatalf("invalid description")
	}
	if A.GetBegin() != begin {
		t.Fatalf("invalid begin")
	}
	if A.GetDeadline() != deadline {
		t.Fatalf("invalid deadline")
	}
	if A.GetMinPrice() != minPrice {
		t.Fatalf("invalid minPrice")
	}
	std.TestSetOrigCaller(user)
	if !A.isOwner() {
		t.Fatalf("invalid owner")
	}
}
