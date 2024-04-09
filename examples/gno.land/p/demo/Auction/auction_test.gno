package auction 

import (
	"std"
	"testing"
	"gno.land/p/demo/testutils"

)// TestAuction_New verifies that a new Auction
// can be initialized correctly
func TestAuction_new(t *testing.T) {
	var (
		titleAuction ="auction title"
		owner 		= testutils.TestAddress("owner")
		description = "description"
		)

	// Create a new Auction instance
A := NewAuction(titleAuction, owner, description)
if A.GetTitle() != titleAuction {
	t.Fatalf("invalid title")
}
if A.GetDescription() != description {
	t.Fatalf("invalid description")
}
if !A.isOwner(owner)  {
	t.Fatalf("invalid owner")
}
}