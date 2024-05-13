package timelock

import (
	"std"
	"time"
	"gno.land/p/demo/accesscontrol"
)

var (
	ac *accesscontrol.AccessControl
	operations map[string]OperationDetail
	minDelay time.Duration
)

type OperationDetail struct {
	scheduledTime time.Time
	action func()
	state OperationState
}

type OperationState int

const (
	Unset OperationState = iota
	Waiting
	Ready
	Done
)

func InitTimelock(minimumDelay time.Duration, admin std.Address) {
	ac = accesscontrol.NewAccessControl()
	operations = make(map[string]OperationDetail)
	minDelay = minimumDelay
	ac.GrantRole("admin", admin)
}

func ConfigRoles(proposer, executor, canceller, admin std.Address) {
	if !ac.HasRole("admin", std.PrevRealm().Addr()) {
		panic("only admin can configure roles")
	}
	ac.GrantRole("proposer", proposer)
	ac.GrantRole("executor", executor)
	ac.GrantRole("canceller", canceller)
	ac.GrantRole("admin", admin)
}

func ScheduleOperation(id string, delay time.Duration, action func()) {
	if !ac.HasRole("proposer", std.PrevRealm().Addr()) {
		panic("unauthorized: only proposer can schedule operations")
	}

	if delay < minDelay {
		panic("scheduled delay is too short")
	}

	operations[id] = OperationDetail{
		state: Waiting,
		scheduledTime: time.Now().Add(delay),
		action: action,
	}
}

func ExecuteOperation(id string) {
    op, exists := operations[id]
    if !exists || op.state != Ready {
        panic("Operation is not ready or does not exist")
    }
    if !ac.HasRole("executor", std.PrevCaller()) {
        panic("Unauthorized: Only executor can perform operations")
    }
    op.action()
    op.state = Done
    operations[id] = op
}

func CancelOperation(id string) {
    if !ac.HasRole("canceller", std.PrevCaller()) {
        panic("Unauthorized: Only canceller can cancel operations")
    }
    _, exists := operations[id]
    if !exists {
        panic("Operation does not exist")
    }
    delete(operations, id)
}

func UpdateMinDelay(newDelay time.Duration) {
    if !ac.HasRole("admin", std.PrevCaller()) {
        panic("Unauthorized: Only admin can update the minimum delay")
    }
    minDelay = newDelay
}