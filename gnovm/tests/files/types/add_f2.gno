package main

import (
	"strconv"
)

type E interface {
	Error() string
}

type Error1 int64

func (e Error1) Error() string {
	return "error: " + strconv.Itoa(int(e))
}

type Error2 int

func (e Error2) Error() string {
	return "error: " + strconv.Itoa(int(e))
}

// both not const, and both interface
func main() {
	var e1 E = Error1(0)
	var e2 E = Error2(0)
	println(e1 + e2)
}

// Error:
// main/add_f2.gno:27:10-17: operator + not defined on: InterfaceKind

// TypeCheckError:
// main/add_f2.gno:27:10: invalid operation: operator + not defined on e1 (variable of interface type E)
