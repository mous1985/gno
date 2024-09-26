package myui

import (
	"strings"

	"gno.land/p/demo/ufmt"
)

// Header of level 1 to 6
func (ctx *Context) H(level int, text string) {
	if level < 1 || level > 6 {
		level = 1
	}
	ctx.buf.WriteString(strings.Repeat("#", level) + " " + text + "\n")
}

// add a paragraph of text to a buffer
func (ctx *Context) P(text string) {
	ctx.buf.WriteString("\n" + text + "\n")
}

// Create an unordered list from a slice of strings.
func (ctx *Context) UL(items []string) {
	for _, item := range items {
		ctx.buf.WriteString("- " + item + "\n")
	}
}

// Print an ordered list of items to buf.
func (ctx *Context) OL(items []string) {
	for i, item := range items {
		ctx.buf.WriteString(ufmt.Sprintf("%d. %s\n", i+1, item))
	}
}

// write horizontal rule to buf
func (ctx *Context) HR() {
	ctx.buf.WriteString("\n---\n")
}

// **strong text**
func (ctx *Context) Strong(text string) {
	ctx.buf.WriteString("**" + text + "**")
}

// Emphasis: _text_
func (ctx *Context) Link(text, url string) {
	ctx.buf.WriteString("[" + text + "](" + url + ")")
}

// Code writes a code block or inline code to the buffer.
func (ctx *Context) Code(text string, block bool) {
	if block {
		ctx.buf.WriteString("\n```\n" + text + "\n```\n")
	} else {
		ctx.buf.WriteString("`" + text + "`")
	}
}

// Table
type Table struct {
	Headers []string
	Rows    [][]string
}

func (ctx *Context) Table(table Table) {
	// Render the headers
	ctx.buf.WriteString("|")
	for _, header := range table.Headers {
		ctx.buf.WriteString(" " + header + " |")
	}
	ctx.buf.WriteString("\n")

	// Render the separator
	ctx.buf.WriteString("|")
	for range table.Headers {
		ctx.buf.WriteString(" --- |")
	}
	ctx.buf.WriteString("\n")

	// Render each row
	for _, row := range table.Rows {
		ctx.buf.WriteString("|")
		for _, cell := range row {
			ctx.buf.WriteString(" " + cell + " |")
		}
		ctx.buf.WriteString("\n")
	}
}
