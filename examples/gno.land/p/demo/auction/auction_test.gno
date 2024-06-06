package auction

import (
	"std"
	"testing"
	"time"

	"gno.land/p/demo/testutils"
)

// Helper function to set the mock current time
func setMockTime(t time.Time) {
	currentTime = t
}

// Helper function to reset the mock current time
func resetMockTime() {
	currentTime = time.Time{}
}

// TestNewAuction verifies that a new auction can be created correctly
func TestNewAuction(t *testing.T) {
	title := "Test Auction"
	owner := testutils.TestAddress("owner")
	description := "A simple test auction"
	begin := time.Now()
	end := begin.Add(24 * time.Hour)
	minPrice := uint64(100)

	auc := NewAuction(title, owner, description, begin, end, minPrice)
	if auc.Title != title {
		t.Fatalf("Expected title to be %s, got %s", title, auc.Title)
	}
	if auc.Owner != owner {
		t.Fatalf("Expected owner to be %s, got %s", owner, auc.Owner)
	}
	if auc.Description != description {
		t.Fatalf("Expected description to be %s, got %s", description, auc.Description)
	}
	if !auc.GetBegin().Equal(begin) {
		t.Fatalf("Expected begin time to be %v, got %v", begin, auc.GetBegin())
	}
	if !auc.GetEnd().Equal(end) {
		t.Fatalf("Expected end time to be %v, got %v", end, auc.GetEnd())
	}
	if auc.GetPrice() != minPrice {
		t.Fatalf("Expected price to be %d, got %d", minPrice, auc.GetPrice())
	}
	if len(auc.GetBids()) != 0 {
		t.Fatalf("Expected no bids, got %d", len(auc.GetBids()))
	}
}

// TestAddBid verifies that bids can be added correctly
func TestAddBid(t *testing.T) {
	title := "Test Auction"
	owner := testutils.TestAddress("owner")
	bidder1 := testutils.TestAddress("bidder1")
	bidder2 := testutils.TestAddress("bidder2")
	description := "A simple test auction"
	begin := time.Now()
	end := begin.Add(24 * time.Hour)
	minPrice := uint64(100)

	auc := NewAuction(title, owner, description, begin, end, minPrice)

	// Simulate time to be after auction start
	setMockTime(begin.Add(time.Second))

	// Place first bid
	auc.AddBid(bidder1, 200)
	if auc.GetPrice() != 200 {
		t.Fatalf("Expected highest bid to be 200, got %d", auc.GetPrice())
	}

	// Place second bid
	auc.AddBid(bidder2, 300)
	if auc.GetPrice() != 300 {
		t.Fatalf("Expected highest bid to be 300, got %d", auc.GetPrice())
	}

	// Verify bids
	bids := auc.GetBids()
	if len(bids) != 2 {
		t.Fatalf("Expected 2 bids, got %d", len(bids))
	}
	if bids[0].Bidder != bidder1 || bids[0].Amount != 200 {
		t.Fatalf("First bid incorrect")
	}
	if bids[1].Bidder != bidder2 || bids[1].Amount != 300 {
		t.Fatalf("Second bid incorrect")
	}
}

// TestEndAuction verifies that the auction can be ended correctly
func TestEndAuction(t *testing.T) {
	title := "Test Auction"
	owner := testutils.TestAddress("owner")
	bidder1 := testutils.TestAddress("bidder1")
	bidder2 := testutils.TestAddress("bidder2")
	description := "A simple test auction"
	begin := time.Now()
	end := begin.Add(24 * time.Hour)
	minPrice := uint64(100)

	auc := NewAuction(title, owner, description, begin, end, minPrice)

	// Simulate time to be after auction start
	setMockTime(begin.Add(time.Second))

	// Place bids
	auc.AddBid(bidder1, 200)
	auc.AddBid(bidder2, 300)

	// Simulate time to be after auction end
	setMockTime(end.Add(time.Second))

	// End auction
	auc.EndAuction(owner)

	// Ensure auction is closed
	if auc.State != "closed" {
		t.Fatalf("Expected auction state to be 'closed', got %s", auc.State)
	}

	// Ensure event emission
	// std.AssertEvent(t, "AuctionEnded", "winner", bidder2.String(), "amount", "300")
}
