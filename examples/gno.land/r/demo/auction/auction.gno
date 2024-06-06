package auction

import (
	"std"
	"strconv"
	"strings"
	"time"

	auctionp "gno.land/p/demo/auction"
)

var (
	auctionList []*auctionp.Auction
	currentTime time.Time
)

func init() {
	auctionList = []*auctionp.Auction{}
}

func now() time.Time {
	if !currentTime.IsZero() {
		return currentTime
	}
	return time.Now()
}

// CreateAuction creates a new auction in the realm
func CreateAuction(
	title string,
	description string,
	begin int64,
	end int64,
	price uint64,
) string {
	caller := std.GetOrigCaller()

	if begin < now().Unix() {
		panic("begin has to be in the future")
	}
	if end <= now().Unix() {
		panic("end has to be in the future")
	}
	if end <= begin {
		panic("end has to be after begin")
	}
	if price <= 0 {
		panic("price has to be positive")
	}

	auc := auctionp.NewAuction(
		title,
		caller,
		description,
		time.Unix(begin, 0),
		time.Unix(end, 0),
		price,
	)
	auctionList = append(auctionList, auc)
	return "Auction created successfully"
}

// PlaceBid places a bid on an auction
func PlaceBid(auctionID int, bidAmount uint64) string {
	caller := std.GetOrigCaller()
	if auctionID >= len(auctionList) {
		panic("auction does not exist")
	}
	auction := auctionList[auctionID]
	if auction.GetBegin().After(now()) {
		return "Auction has not started yet"
	}
	if auction.GetEnd().Before(now()) {
		return "Auction has ended"
	}
	if auction.IsOwnedBy(caller) {
		return "Owner cannot bid"
	}
	if auction.GetPrice() >= bidAmount {
		return "Bid must be higher than the current price"
	}

	auction.AddBid(caller, bidAmount)
	return "Bid placed successfully"
}

// EndAuction ends an auction
func EndAuction(auctionID int) string {
	caller := std.GetOrigCaller()
	if auctionID >= len(auctionList) {
		panic("auction does not exist")
	}
	auction := auctionList[auctionID]
	if !auction.IsOwnedBy(caller) {
		panic("Only the owner can end the auction")
	}
	auction.EndAuction(caller)
	return "Auction ended successfully"
}

// SetAuctionTitle allows the owner to set the auction title
func SetAuctionTitle(auctionID int, title string) {
	caller := std.GetOrigCaller()
	if auctionID >= len(auctionList) {
		panic("auction does not exist")
	}
	auction := auctionList[auctionID]
	auction.SetTitle(caller, title)
}

// SetAuctionDescription allows the owner to set the auction description
func SetAuctionDescription(auctionID int, description string) {
	caller := std.GetOrigCaller()
	if auctionID >= len(auctionList) {
		panic("auction does not exist")
	}
	auction := auctionList[auctionID]
	auction.SetDescription(caller, description)
}

// Render renders the state of the realm
func Render(path string) string {
	if path == "" {
		return renderHomepage()
	}
	return "unknown page"
}

// renderHomepage renders the homepage of the realm
func renderHomepage() string {
	var b strings.Builder
	b.WriteString("<h1><center>Auctions</center></h1>\n\n")
	if len(auctionList) == 0 {
		b.WriteString("## No auctions available\n")
		return b.String()
	}
	for i, auc := range auctionList {
		b.WriteString("## " + auc.Title + "\n")
		// b.WriteString("### Owner: " + auc.Owner.string() + "\n")
		b.WriteString("### Description: " + auc.Description + "\n\n")
		b.WriteString("This auction starts on: " + auc.GetBegin() + " and ends on: " + auc.GetEnd() + "\n\n")
		b.WriteString("### Current Price: " + strconv.FormatUint(auc.GetPrice(), 10) + "\n")
		b.WriteString("[View Auction](" + strconv.Itoa(i) + ")\n")
	}
	return b.String()
}

// Helper function to set the mock current time (useful for testing)
func setCurrentTime(t time.Time) {
	currentTime = t
}

// Helper function to reset the mock current time
func resetCurrentTime() {
	currentTime = time.Time{}
}
