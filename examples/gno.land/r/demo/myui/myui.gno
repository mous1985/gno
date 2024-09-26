package myui

import (
	u "gno.land/p/demo/ui/myui"
)

var (
	title   string
	content []string
)

func init() {
	title = "Welcome"
	// content = []string{
	// 	"Introduction",
	// 	"Goals",
	// 	"Conclusion",
	// }
}

// Add content to the existing content array
// func AddContent(newContent string) {
// 	if newContent != "" {
// 		content = append(content, newContent)
// 	}
// }

func Render(_ string) string {
	// Create a new rendering context
	ctx := u.NewContext()

	// Render a main header
	ctx.H(1, "Welcome to MyUI")
	ctx.P("This section demonstrates the use of  components in MyUI.")

	//  Render a subtitle with a description
	ctx.H(2, "Basic Components")
	ctx.P("Here are some basic components like headers, paragraphs, and lists.")

	// Render an unordered list
	ctx.H(3, "Unordered List")
	ctx.UL([]string{"Item 1", "Item 2", "Item 3"})

	//  Render an ordered list
	ctx.H(3, "Ordered List")
	ctx.OL([]string{"First", "Second", "Third"})

	//  Render a horizontal line
	ctx.HR()

	//  Bold text and a link example
	ctx.H(2, "Text and Links")
	ctx.H(3, "Text Formatting")
	ctx.P("You can use ")
	ctx.Strong("bold text")
	ctx.P(" and ")
	ctx.Link("links", "https://gno.land")
	ctx.P(" in your content.")

	//  Render a code block example
	ctx.H(3, "Code Example")
	ctx.Code("func example() { ufmt.Println(\"Hello, Gno!\") }", true)

	// Render a DOM example
	dom := u.DOM{
		Title:   "DOM Example",
		Content: "This is dynamically generated content using the DOM structure.",
		Footer:  "Generated using Gno UI.",
	}
	ctx.HR()
	ctx.H(2, "DOM Rendering")
	dom.Render(ctx)

	//  End with another horizontal line
	ctx.HR()

	// Return the rendered content as a string
	return ctx.String()
}
