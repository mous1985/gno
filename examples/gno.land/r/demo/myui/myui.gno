package myui

import (
   
    u "gno.land/p/demo/ui/myui" 
)

var title string
var content []string


func init() {
    title = "Welcome"
    content = []string{
        "Introduction",
        "Goals",
        "Conclusion",
    }
}

// Add content to the existing content array
func AddContent(newContent string) {
    if newContent != "" {
        content = append(content, newContent)
    }
}

func Render(_ string) string {
    // Create a new rendering context
    ctx := u.NewContext()

    // 1. Render a main header
    ctx.H(1, "Welcome to MyUI")
    ctx.P("This section demonstrates the use of various components in MyUI.")

    // 2. Render a subtitle with a description
    ctx.H(2, "Basic Components")
    ctx.P("Here are some basic components like headers, paragraphs, and lists.")

    // 3. Render an unordered list
    ctx.H(3, "Unordered List")
    ctx.UL([]string{"Item 1", "Item 2", "Item 3"})

    // 4. Render an ordered list
    ctx.H(3, "Ordered List")
    ctx.OL([]string{"First", "Second", "Third"})

    // 5. Render a horizontal line
    ctx.HR()

    // 6. Bold text and a link example
    // 6. Bold text and link example (fix: no return value)
    ctx.H(3, "Text Formatting")
    ctx.P("You can use ")      
    ctx.Strong("bold text")     
    ctx.P(" and ")              
    ctx.Link("links", "https://gno.land") 
    ctx.P(" in your content.")  // Finish the paragraph

    // 7. Render a code block example
    ctx.H(3, "Code Example")
    ctx.Code("func example() { fmt.Println(\"Hello, Gno!\") }", true)

    // 8. Render a DOM example
    dom := u.DOM{
        Title:   "DOM Example",
        Content: "This is dynamically generated content using the DOM structure.",
        Footer:  "Generated using Gno UI.",
    }
    ctx.HR() // Horizontal line
    ctx.H(2, "DOM Rendering")
    dom.Render(ctx)

    // 9. End with another horizontal line
    ctx.HR()

    // Return the rendered content as a string
    return ctx.String()
}