package main

func foo() (int, bool) {
	return 1, true
}

func main() {
	var a, b = 2, foo()

	println(a, b)
}

// Error:
// main/var21.gno:8:6-21: multiple-value foo<VPBlock(3,0)> (value of type [int bool]) in single-value context

// TypeCheckError:
// main/var21.gno:8:16: multiple-value foo() (value of type (int, bool)) in single-value context
