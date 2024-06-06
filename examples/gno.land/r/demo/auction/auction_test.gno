package auction

import (
	"std"
	"strings"
	"testing"
	"time"

	auctionp "gno.land/p/demo/auction"
)

// Helper function to set the mock current time
func setMockTime(t time.Time) {
	setCurrentTime(t)
}

// Helper function to reset the mock current time
func resetMockTime() {
	resetCurrentTime()
}

func TestAuctionRealm(t *testing.T) {
	// Simulate the admin creating an auction
	adminAddr := std.Address("admin")

	// Set the caller to admin
	std.TestSetOrigCaller(adminAddr)

	// Create an auction that starts almost immediately
	begin := now().Add(1 * time.Second).Unix() // Auction begins in 1 second
	end := now().Add(24 * time.Hour).Unix()    // Auction ends in 24 hours
	result := CreateAuction("Test Auction", "A simple test auction", begin, end, 100)
	if result != "Auction created successfully" {
		t.Fatalf("Expected auction creation success, got: %s", result)
	}
	if len(auctionList) != 1 {
		t.Fatalf("Expected 1 auction, got: %d", len(auctionList))
	}

	// Simulate time passing to start the auction
	setMockTime(now().Add(2 * time.Second))

	// Place bids by different users
	user1 := std.Address("user1")
	user2 := std.Address("user2")

	// Set the caller to user1 and place a bid
	std.TestSetOrigCaller(user1)
	result = PlaceBid(0, 200)
	if result != "Bid placed successfully" {
		t.Fatalf("Expected bid placement success, got: %s", result)
	}

	// Set the caller to user2 and place a bid
	std.TestSetOrigCaller(user2)
	result = PlaceBid(0, 300)
	if result != "Bid placed successfully" {
		t.Fatalf("Expected bid placement success, got: %s", result)
	}

	// Ensure the highest bid is correct
	aucInterface := auctionList[0]
	auc := aucInterface
	if auc.GetPrice() != 300 {
		t.Fatalf("Expected highest bid to be 300, got: %d", auc.GetPrice())
	}

	// Set the caller to admin and end the auction
	std.TestSetOrigCaller(adminAddr)
	result = EndAuction(0)
	if result != "Auction ended successfully" {
		t.Fatalf("Expected auction end success, got: %s", result)
	}

	// Render the state and verify
	state := Render("")
	if !strings.Contains(state, "Test Auction") {
		t.Fatalf("Auction should be in the rendered state")
	}

	resetMockTime()
}
