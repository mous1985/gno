package myui



// Struct representing the DOM of a page

type DOM struct {
    Title   string   
    Content string   
    Footer  string   
}



// Function to render the DOM structure into a buffer
func (dom DOM) Render(ctx *Context)  {
    
    // Generate the page layout with the title and content
    ctx.PageLayout(dom.Title, dom.Content)
    
    // If a custom footer is provided, render it as well
    if dom.Footer != "" {
        ctx.P(dom.Footer) 
    }
    
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

