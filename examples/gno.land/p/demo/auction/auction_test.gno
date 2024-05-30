package auction

import (
	"std"
	"testing"
	"time"
)

// Helper function to set mock current time
func setcurrentTime(t time.Time) {
	currentTime = t
}

// Helper function to reset mock current time
func resetcurrentTime() {
	currentTime = time.Time{}
}

// TestNewAuction verifies that a new Auction can be initialized correctly
func TestNewAuction(t *testing.T) {
	var (
		title       = "Test Auction"
		owner       = std.Address("owner")
		description = "A simple test auction"
		begin       = now().Add(1 * time.Second)
		end         = now().Add(24 * time.Hour)
		minPrice    = uint64(100)
	)

	// Create a new Auction instance
	auction := NewAuction(title, owner, description, begin, end, minPrice)

	if auction.GetTitle() != title {
		t.Fatalf("Expected title %s, got %s", title, auction.GetTitle())
	}
	if auction.GetOwner() != owner {
		t.Fatalf("Expected owner %s, got %s", owner, auction.GetOwner())
	}
	if auction.GetDescription() != description {
		t.Fatalf("Expected description %s, got %s", description, auction.GetDescription())
	}
	if auction.GetBegin() != begin {
		t.Fatalf("Expected begin time %v, got %v", begin, auction.GetBegin())
	}
	if auction.GetEnd() != end {
		t.Fatalf("Expected end time %v, got %v", end, auction.GetEnd())
	}
	if auction.GetPrice() != minPrice {
		t.Fatalf("Expected min price %d, got %d", minPrice, auction.GetPrice())
	}
}

// TestAddBid verifies that bids can be added correctly to an auction
func TestAddBid(t *testing.T) {
	var (
		title       = "Test Auction"
		owner       = std.Address("owner")
		description = "A simple test auction"
		begin       = now().Add(1 * time.Second)
		end         = now().Add(24 * time.Hour)
		minPrice    = uint64(100)
	)

	auction := NewAuction(title, owner, description, begin, end, minPrice)

	// Set mock current time to start the auction
	setcurrentTime(now().Add(2 * time.Second))

	// Add a bid
	bidder1 := std.Address("bidder1")
	amount1 := uint64(200)
	auction.AddBid(bidder1, amount1)

	// Verify the highest bid
	if auction.GetPrice() != amount1 {
		t.Fatalf("Expected highest bid %d, got %d", amount1, auction.GetPrice())
	}

	// Add another bid
	bidder2 := std.Address("bidder2")
	amount2 := uint64(300)
	auction.AddBid(bidder2, amount2)

	// Verify the highest bid
	if auction.GetPrice() != amount2 {
		t.Fatalf("Expected highest bid %d, got %d", amount2, auction.GetPrice())
	}

	// Verify the number of bids
	if len(auction.GetBids()) != 2 {
		t.Fatalf("Expected number of bids %d, got %d", 2, len(auction.GetBids()))
	}

	resetcurrentTime()
}

// TestEndAuction verifies that the auction can be ended correctly
func TestEndAuction(t *testing.T) {
	var (
		title       = "Test Auction"
		owner       = std.Address("owner")
		description = "A simple test auction"
		begin       = now().Add(1 * time.Second)
		end         = now().Add(5 * time.Second)
		minPrice    = uint64(100)
	)

	auction := NewAuction(title, owner, description, begin, end, minPrice)

	// Set mock current time to start the auction
	setcurrentTime(now().Add(2 * time.Second))

	// Add a bid
	bidder1 := std.Address("bidder1")
	amount1 := uint64(200)
	auction.AddBid(bidder1, amount1)

	// Add another bid
	bidder2 := std.Address("bidder2")
	amount2 := uint64(300)
	auction.AddBid(bidder2, amount2)

	// Set mock current time to end the auction
	setcurrentTime(now().Add(6 * time.Second))

	// End the auction
	auction.EndAuction()

	resetcurrentTime()
}

// TestBidderCannotBeOwner verifies that the owner cannot place bids in their own auction
func TestBidderCannotBeOwner(t *testing.T) {
	var (
		title       = "Test Auction"
		owner       = std.Address("owner")
		description = "A simple test auction"
		begin       = now().Add(1 * time.Second)
		end         = now().Add(24 * time.Hour)
		minPrice    = uint64(100)
	)

	auction := NewAuction(title, owner, description, begin, end, minPrice)

	// Set mock current time to start the auction
	setcurrentTime(now().Add(2 * time.Second))

	defer func() {
		if r := recover(); r == nil {
			t.Fatalf("Expected panic when owner tries to bid")
		}
	}()

	auction.AddBid(owner, 200)

	resetcurrentTime()
}

// TestAuctionCannotStartInPast verifies that an auction cannot be created with a start time in the past
func TestAuctionCannotStartInPast(t *testing.T) {
	var (
		title       = "Test Auction"
		owner       = std.Address("owner")
		description = "A simple test auction"
		begin       = now().Add(-1 * time.Second) // Begin time in the past
		end         = now().Add(24 * time.Hour)
		minPrice    = uint64(100)
	)

	defer func() {
		if r := recover(); r == nil {
			t.Fatalf("Expected panic when auction start time is in the past")
		}
	}()

	NewAuction(title, owner, description, begin, end, minPrice)
}

// TestBidAmountMustBeHigherThanCurrentHighest verifies that bids must be higher than the current highest bid
func TestBidAmountMustBeHigherThanCurrentHighest(t *testing.T) {
	var (
		title       = "Test Auction"
		owner       = std.Address("owner")
		description = "A simple test auction"
		begin       = now().Add(1 * time.Second)
		end         = now().Add(24 * time.Hour)
		minPrice    = uint64(100)
	)

	auction := NewAuction(title, owner, description, begin, end, minPrice)

	// Set mock current time to start the auction
	setcurrentTime(now().Add(2 * time.Second))

	// Add a bid
	bidder1 := std.Address("bidder1")
	amount1 := uint64(200)
	auction.AddBid(bidder1, amount1)

	defer func() {
		if r := recover(); r == nil {
			t.Fatalf("Expected panic when bid amount is not higher than current highest bid")
		}
	}()

	// Try to add a lower bid
	auction.AddBid(bidder1, 150)

	resetcurrentTime()
}
