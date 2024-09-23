package myui



// Struct representing the DOM of a page

type DOM struct {
    Title   string   
    Content string   
    Footer  string   
}



// Function to render the DOM structure into a buffer
func (dom DOM) Render() string {
    buf := getBuffer()
    // Generate the page layout with the title and content
    PageLayout(dom.Title, dom.Content)
    
    // If a custom footer is provided, render it as well
    if dom.Footer != "" {
        P(dom.Footer) 
    }
    return buf.String()
}

// Function to update the content of the DOM
// Replaces the current content with new content.
func (dom *DOM) UpdateContent(newContent string) {
    dom.Content = newContent // Updates the content field with new content
}

// Function to append additional content to the existing DOM content
func (dom *DOM) AppendContent(additionalContent string) {
    dom.Content += "\n" + additionalContent 
}

