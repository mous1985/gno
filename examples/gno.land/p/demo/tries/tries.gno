package tries

const ALPHABET_SIZE = 26

type Trie struct {
	root *Node
}

func NewTrie() *Trie {
	return &Trie{
		root: NewNode(),
	}
}

func (trie *Trie) Size() int {
	return trie.sizeHelper(trie.root)
}

func (trie *Trie) sizeHelper(node *Node) int {
	if node == nil {
		return 0
	}
	size := 0
	if node.isEnd {
		size++
	}
	for _, child := range node.children {
		size += trie.sizeHelper(child)
	}
	return size
}

func (trie *Trie) Has(word string) bool {
	return trie.root.Has(word)
}

func (trie *Trie) Get(word string) bool {
	return trie.root.Get(word)
}

func (trie *Trie) Set(word string) {
	trie.root.Set(word)
}

func (trie *Trie) Remove(word string) bool {
	return trie.root.Remove(word)
}

type IterCbFn func(word string) bool

func (trie *Trie) Iterate(prefix string, cb IterCbFn) {
	trie.iterateHelper(trie.root, prefix, "", cb)
}

func (trie *Trie) iterateHelper(node *Node, prefix, currentWord string, cb IterCbFn) bool {
	if node == nil {
		return false
	}
	if node.isEnd && len(currentWord) >= len(prefix) && currentWord[:len(prefix)] == prefix {
		if cb(currentWord) {
			return true
		}
	}
	for i, child := range node.children {
		if child != nil {
			if trie.iterateHelper(child, prefix, currentWord+string('a'+i), cb) {
				return true
			}
		}
	}
	return false
}

func (trie *Trie) ReverseIterate(prefix string, cb IterCbFn) {
	trie.reverseIterateHelper(trie.root, prefix, "", cb)
}

func (trie *Trie) reverseIterateHelper(node *Node, prefix, currentWord string, cb IterCbFn) bool {
	if node == nil {
		return false
	}
	for i := ALPHABET_SIZE - 1; i >= 0; i-- {
		child := node.children[i]
		if child != nil {
			if trie.reverseIterateHelper(child, prefix, currentWord+string('a'+i), cb) {
				return true
			}
		}
	}
	if node.isEnd && len(currentWord) >= len(prefix) && currentWord[:len(prefix)] == prefix {
		if cb(currentWord) {
			return true
		}
	}
	return false
}
