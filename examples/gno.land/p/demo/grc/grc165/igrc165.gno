package grc165

import "bytes"
	
type IGRC165 interface {
	SupportsInterface(interfaceID [4]byte) (bool, error)
}