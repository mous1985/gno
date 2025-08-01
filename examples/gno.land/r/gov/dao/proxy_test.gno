package dao

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/urequire"
)

const (
	v3 = "gno.land/r/gov/dao/v3/impl"
	v4 = "gno.land/r/gov/dao/v4/impl"
	v5 = "gno.land/r/gov/dao/v5/impl"
	v6 = "gno.land/r/gov/dao/v6/impl"
)

const invalid = "gno.land/r/invalid/dao"

var alice = testutils.TestAddress("alice")

func TestProxy_Functions(cur realm, t *testing.T) {
	// initialize tests
	UpdateImpl(cross, UpdateRequest{
		DAO:         &dummyDao{},
		AllowedDAOs: []string{v3},
	})

	// invalid package cannot add a new dao in charge
	testing.SetRealm(std.NewCodeRealm(invalid))
	urequire.AbortsWithMessage(t, "permission denied for prev realm: gno.land/r/invalid/dao", func() {
		UpdateImpl(cross, UpdateRequest{
			DAO: &dummyDao{},
		})
	})

	// dao in charge can add a new dao
	testing.SetRealm(std.NewCodeRealm(v3))
	urequire.NotPanics(t, func() {
		UpdateImpl(cross, UpdateRequest{
			DAO: &dummyDao{},
		})
	})

	// v3 that is in charge adds v5 in charge
	testing.SetRealm(std.NewCodeRealm(v3))
	urequire.NotPanics(t, func() {
		UpdateImpl(cross, UpdateRequest{
			DAO:         &dummyDao{},
			AllowedDAOs: []string{v3, v5},
		})
	})

	// v3 can still do updates
	testing.SetRealm(std.NewCodeRealm(v3))
	urequire.NotPanics(t, func() {
		UpdateImpl(cross, UpdateRequest{
			AllowedDAOs: []string{v4},
		})
	})

	// not after removing himself from allowedDAOs list
	testing.SetRealm(std.NewCodeRealm(v3))
	urequire.AbortsWithMessage(t, "permission denied for prev realm: gno.land/r/gov/dao/v3/impl", func() {
		UpdateImpl(cross, UpdateRequest{
			AllowedDAOs: []string{v3},
		})
	})

	var pid ProposalID
	testing.SetRealm(std.NewUserRealm(alice))
	urequire.NotPanics(t, func() {
		e := NewSimpleExecutor(
			func(realm) error {
				return nil
			},
			"",
		)
		pid = MustCreateProposal(cross, NewProposalRequest("Proposal Title", "Description", e))
	})

	p := MustGetProposal(cross, 1000)
	if p != nil {
		panic("proposal must be nil")
	}
	p = MustGetProposal(cross, pid)
	urequire.Equal(t, "Proposal Title", p.Title())
	urequire.Equal(t, p.Author().String(), alice.String())

	// need to switch the context back to v4
	testing.SetRealm(std.NewCodeRealm(v4))
	urequire.Equal(
		t,
		"Render: gno.land/r/gov/dao/test",
		Render("test"),
	)

	// reset state
	testing.SetRealm(std.NewCodeRealm(v4))
	UpdateImpl(cross, UpdateRequest{
		DAO:         &dummyDao{},
		AllowedDAOs: []string{},
	})
}

type dummyDao struct{}

func (dd *dummyDao) PreCreateProposal(r ProposalRequest) (std.Address, error) {
	return std.OriginCaller(), nil
}

func (dd *dummyDao) PostCreateProposal(r ProposalRequest, pid ProposalID) {
}

func (dd *dummyDao) VoteOnProposal(r VoteRequest) error {
	return nil
}

func (dd *dummyDao) PreGetProposal(pid ProposalID) error {
	return nil
}

func (dd *dummyDao) PostGetProposal(pid ProposalID, p *Proposal) error {
	return nil
}

func (dd *dummyDao) PreExecuteProposal(pid ProposalID) (bool, error) {
	return true, nil
}

func (dd *dummyDao) Render(pkgpath string, path string) string {
	return "Render: " + pkgpath + "/" + path
}
