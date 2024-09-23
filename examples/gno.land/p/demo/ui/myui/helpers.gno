package myui


// Helper function to join multiple strings into a buffer
// It appends each string followed by a newline into the provided buffer.
func (ctx *Context) JoinStrings( parts ...string) {
   
    for _, part := range parts {
        ctx.buf.WriteString(part + "\n")
    }
}

// Helper function to validate a link
// Ensures that a link has either a path or a URL, but not both.
func (ctx *Context) ValidateLink(path, url string) bool {
    if path != "" && url != "" {
        return false // Invalid if both path and URL are provided
    }
    return true
}
