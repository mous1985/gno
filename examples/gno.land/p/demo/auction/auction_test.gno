package auction

import (
	"std"
	"testing"
	"time"
)

func setCurrentTime(t time.Time) {
	currentTime = t
}

func resetCurrentTime() {
	currentTime = time.Time{}
}

func TestNewAuction(t *testing.T) {
	owner := std.Address("owner")
	begin := time.Now().Add(1 * time.Hour)
	end := time.Now().Add(24 * time.Hour)
	minPrice := uint64(100)

	auction := NewAuction("Test Auction", owner, "This is a test auction", begin, end, minPrice)

	if auction.Title != "Test Auction" {
		t.Fatalf("expected auction title to be 'Test Auction', got '%s'", auction.Title)
	}
	if auction.Owner != owner {
		t.Fatalf("expected auction owner to be '%s', got '%s'", owner, auction.Owner)
	}
	if auction.Description != "This is a test auction" {
		t.Fatalf("expected auction description to be 'This is a test auction', got '%s'", auction.Description)
	}
	if auction.GetBegin() != begin {
		t.Fatalf("expected auction begin time to be '%s', got '%s'", begin, auction.GetBegin())
	}
	if auction.GetEnd() != end {
		t.Fatalf("expected auction end time to be '%s', got '%s'", end, auction.GetEnd())
	}
	if auction.GetPrice() != minPrice {
		t.Fatalf("expected auction price to be '%d', got '%d'", minPrice, auction.GetPrice())
	}
	if auction.State != "upcoming" {
		t.Fatalf("expected auction state to be 'upcoming', got '%s'", auction.State)
	}
}

func TestAddBid(t *testing.T) {
	owner := std.Address("owner")
	bidder1 := std.Address("bidder1")
	bidder2 := std.Address("bidder2")
	begin := time.Now().Add(1 * time.Hour)
	end := time.Now().Add(24 * time.Hour)
	minPrice := uint64(100)

	auction := NewAuction("Test Auction", owner, "This is a test auction", begin, end, minPrice)

	// Test before auction starts
	defer func() {
		if r := recover(); r == nil {
			t.Fatalf("expected panic when bidding before auction starts")
		}
	}()
	setCurrentTime(time.Now())
	auction.AddBid(bidder1, 200)
	resetCurrentTime()

	// Test successful bid
	setCurrentTime(begin.Add(1 * time.Second))
	auction.AddBid(bidder1, 200)
	resetCurrentTime()

	if auction.GetPrice() != 200 {
		t.Fatalf("expected auction price to be '200', got '%d'", auction.GetPrice())
	}
	if len(auction.GetBids()) != 1 {
		t.Fatalf("expected number of bids to be '1', got '%d'", len(auction.GetBids()))
	}
	if auction.GetBids()[0].Bidder != bidder1 {
		t.Fatalf("expected bidder to be 'bidder1', got '%s'", auction.GetBids()[0].Bidder)
	}

	// Test higher bid
	setCurrentTime(begin.Add(2 * time.Second))
	auction.AddBid(bidder2, 300)
	resetCurrentTime()

	if auction.GetPrice() != 300 {
		t.Fatalf("expected auction price to be '300', got '%d'", auction.GetPrice())
	}
	if len(auction.GetBids()) != 2 {
		t.Fatalf("expected number of bids to be '2', got '%d'", len(auction.GetBids()))
	}
	if auction.GetBids()[1].Bidder != bidder2 {
		t.Fatalf("expected bidder to be 'bidder2', got '%s'", auction.GetBids()[1].Bidder)
	}

	// Test bid lower than current price
	defer func() {
		if r := recover(); r == nil {
			t.Fatalf("expected panic when bidding with lower amount than current price")
		}
	}()
	setCurrentTime(begin.Add(3 * time.Second))
	auction.AddBid(bidder1, 250)
	resetCurrentTime()
}

func TestEndAuction(t *testing.T) {
	owner := std.Address("owner")
	bidder := std.Address("bidder")
	begin := time.Now().Add(1 * time.Hour)
	end := time.Now().Add(24 * time.Hour)
	minPrice := uint64(100)

	auction := NewAuction("Test Auction", owner, "This is a test auction", begin, end, minPrice)

	// Test ending auction before it starts
	defer func() {
		if r := recover(); r == nil {
			t.Fatalf("expected panic when ending auction before it starts")
		}
	}()
	setCurrentTime(begin.Add(-1 * time.Hour))
	auction.EndAuction(owner)
	resetCurrentTime()

	// Test ending auction with no bids
	defer func() {
		if r := recover(); r == nil {
			t.Fatalf("expected panic when ending auction with no bids")
		}
	}()
	setCurrentTime(end.Add(1 * time.Second))
	auction.EndAuction(owner)
	resetCurrentTime()

	// Place a bid and end auction
	setCurrentTime(begin.Add(1 * time.Second))
	auction.AddBid(bidder, 200)
	setCurrentTime(end.Add(1 * time.Second))
	auction.EndAuction(owner)
	resetCurrentTime()

	if auction.State != "closed" {
		t.Fatalf("expected auction state to be 'closed', got '%s'", auction.State)
	}
	if len(auction.GetBids()) == 0 {
		t.Fatalf("expected at least one bid to be present")
	}
	if auction.GetBids()[len(auction.GetBids())-1].Bidder != bidder {
		t.Fatalf("expected winner to be 'bidder', got '%s'", auction.GetBids()[len(auction.GetBids())-1].Bidder)
	}
}
