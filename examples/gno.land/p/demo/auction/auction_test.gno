package auction

import (
	"std"
	"testing"
	"time"

	"gno.land/p/demo/testutils"
) // TestAuction_New verifies that a new Auction
// can be initialized correctly
func TestAuction_new(t *testing.T) {
	var (
		title       = "auction title"
		owner       = testutils.TestAddress("owner")
		user        = NewUser("owner", owner)
		description = "description"
		begin       = time.Now()
		deadline    = begin.Add(time.Hour * 24)
		minPrice    = uint64(1)
	)

	// Create a new Auction instance
	A := NewAuction(title, user, description, begin, deadline, minPrice)
	if A.GetTitle() != title {
		t.Fatalf("invalid title")
	}
	if A.GetOwner() != user {
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
	if !A.isOwner() {
		t.Fatalf("invalid owner")
	}
}
