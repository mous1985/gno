package auction 
import (
    "std"
	)
// Main struct
type Auction struct {
	titleAuction string
	owner std.Address
	description string 
}

func NewAuction(
	titleAuction string, 
	owner std.Address,
	description string, 
	) *Auction {
	return &Auction{
		titleAuction: titleAuction,
		description: description,
		owner: owner,
	}
}


func (A Auction) GetTitle() string {
	return A.titleAuction
}
func (A Auction) GetDescription() string {
	return A.description
}

func (A Auction) isOwner(address std.Address) bool {
	return address.String() == A.owner.String()
}

