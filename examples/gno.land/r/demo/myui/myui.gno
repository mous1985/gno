package myui

import (
    "bytes"
    u "gno.land/p/demo/ui/myui" 
)

var title string
var content []string


func init() {
    title = "Welcome to My UI"
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

// Render function to display the components and layouts dynamically
func Render(path string) string {
    var buf bytes.Buffer

    // Test different components based on the path
    //if path == "/home" {
        // Use PageLayout to render the home page
        u.PageLayout(title, "This is the homepage content.")
   // } else if path == "/content" {
        // Use DOM to render a dynamic page with content
        dom := u.DOM{
            Title:   title,
            Content: "Here is some dynamically loaded content.",
            Footer:  "This is the footer text for content page.",
        }
        dom.Render()
   // } else if path == "/list" {
        // Render a list using UnorderedList component
        u.H( 2, "Content List")
        u.UL( content)
    //} else if path == "/add" {
        // Example: Add a new item and render the updated list
        AddContent("Newly added item")
        u.H( 2, "Updated Content List")
        u.UL( content)
    // } else {
    //     // Default: Render a fallback page
    //     u.H(&buf, 1, "Page Not Found")
    //     u.P(&buf, "The page you are looking for does not exist.")
    // }

    return buf.String() // Return the rendered content as a string
}
