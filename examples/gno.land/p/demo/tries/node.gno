package tries

// Node represents a node in a trie data structure.
type Node struct {
	children [ALPHABET_SIZE]*Node
	isEnd    bool // Flag to indicate if the node represents the end of a word
}

// NewNode creates a new instance of Node.
func NewNode() *Node {
	return &Node{
		children: [ALPHABET_SIZE]*Node{}, // Initialize the children array with nil values
		isEnd:    false,                  // Set isEnd flag to false
	}
}

// IsLeaf checks if the node is a leaf node (i.e., it has no children).
func (node *Node) IsLeaf() bool {
	for _, child := range node.children {
		if child != nil {
			return false // If any child node is not nil, it means the node is not a leaf
		}
	}
	return true // All child nodes are nil, so the node is a leaf
}

// Has checks if the trie contains a given word.
func (node *Node) Has(word string) bool {
	if node == nil {
		return false // If the node is nil, the word is not present in the trie
	}
	currentNode := node
	for _, char := range word {
		charIndex := char - 'a' // Calculate the index of the character in the children array
		if currentNode.children[charIndex] == nil {
			return false // If any required child node is nil, the word is not present in the trie
		}
		currentNode = currentNode.children[charIndex] // Move to the next node
	}
	return currentNode.isEnd // Return the value of isEnd flag of the last node
}

// Get checks if the trie contains a given word.
func (node *Node) Get(word string) bool {
	return node.Has(word) // Get is an alias for Has, so we can simply call Has method
}

// Set adds a word to the trie.
func (node *Node) Set(word string) {
	currentNode := node
	for _, char := range word {
		charIndex := char - 'a' // Calculate the index of the character in the children array
		if currentNode.children[charIndex] == nil {
			currentNode.children[charIndex] = NewNode() // Create a new node if the required child node is nil
		}
		currentNode = currentNode.children[charIndex] // Move to the next node
	}
	currentNode.isEnd = true // Set the isEnd flag of the last node to true
}

// Remove removes a word from the trie.
func (node *Node) Remove(word string) bool {
	return node.removeHelper(word, 0) // Call the removeHelper method to remove the word
}

// removeHelper is a recursive helper method to remove a word from the trie.
func (node *Node) removeHelper(word string, depth int) bool {
	if node == nil {
		return false // If the node is nil, the word is not present in the trie
	}
	if depth == len(word) {
		if node.isEnd {
			node.isEnd = false   // If the node represents the end of the word, set the isEnd flag to false
			return node.IsLeaf() // Return true if the node is a leaf after removing the word
		}
		return false // The node does not represent the end of the word, so the word is not present in the trie
	}
	charIndex := word[depth] - 'a' // Calculate the index of the character in the children array
	if node.children[charIndex] != nil && node.children[charIndex].removeHelper(word, depth+1) {
		node.children[charIndex] = nil      // If the child node is a leaf after removing the word, set it to nil
		return !node.isEnd && node.IsLeaf() // Return true if the node is a leaf after removing the word and it is not the end of another word
	}
	return false // The word is not present in the trie
}
