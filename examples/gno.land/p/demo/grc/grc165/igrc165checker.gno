package grc165

import (
	"std"
)


var INTERFACE_ID_INVALID = [4]byte{0xff, 0xff, 0xff, 0xff}


func SupportsGRC165(account std.Address) (bool, error) {

	SupportsGRC165, err := CallSupportsInterface(account, IGRC165ID)
	if err != nil {
		return false, err
	}
	supportsInvalid, err := CallSupportsInterface(account, INTERFACE_ID_INVALID)
	if err != nil {
		return false, err
	}
	return SupportsGRC165 && !supportsInvalid, nil
}


func SupportsInterface(account std.Address, interfaceID [4]byte) (bool, error) {
	supports, err := SupportsGRC165(account)
	if err != nil || !supports {
		return false, err
	}
	return CallSupportsInterface(account, interfaceID)
}


func GetSupportedInterfaces(account std.Address, interfaceIDs [][4]byte) ([]bool, error) {
	supports, err := SupportsGRC165(account)
	if err != nil {
		return nil, err
	}
	results := make([]bool, len(interfaceIDs))
	if supports {
		for i, id := range interfaceIDs {
			result, err := CallSupportsInterface(account, id)
			if err != nil {
				return nil, err
			}
			results[i] = result
		}
	}
	return results, nil
}


func SupportsAllInterfaces(account std.Address, interfaceIDs [][4]byte) (bool, error) {
	supports, err := SupportsGRC165(account)
	if err != nil || !supports {
		return false, err
	}
	for _, id := range interfaceIDs {
		supported, err := CallSupportsInterface(account, id)
		if err != nil || !supported {
			return false, err
		}
	}
	return true, nil
}


func CallSupportsInterface(account std.Address, interfaceID [4]byte) (bool, error) {
	return account.Call("supportsInterface", interfaceID).(bool)
}
