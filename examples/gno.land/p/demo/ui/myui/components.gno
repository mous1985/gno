package myui

import (
	"bytes"
 	"gno.land/p/demo/ufmt"
 	"strings"
)

func getBuffer() *bytes.Buffer {
    return &bytes.Buffer{}
}

// Header of level 1 to 6
func H(level int, text string) {
    buf := getBuffer()
    if level < 1 || level > 6 {
        level = 1 
    }
    buf.WriteString(strings.Repeat("#", level) + " " + text + "\n")
}

// add a paragraph of text to a buffer
func P(text string) {
    buf := getBuffer()
    buf.WriteString("\n" + text + "\n")
}


// Create an unordered list from a slice of strings.
func UL( items []string) {
    buf := getBuffer()
    for _, item := range items {
        buf.WriteString("- " + item + "\n")
    }
}


// Print an ordered list of items to buf.
func OL(items []string) {
    buf := getBuffer()
    for i, item := range items {
        buf.WriteString(ufmt.Sprintf("%d. %s\n", i+1, item))
    }
}


// write horizontal rule to buf
func HR() {
    buf := getBuffer()
    buf.WriteString("\n---\n")
}


// **strong text**
func Strong(text string) {
    buf := getBuffer()
    buf.WriteString("**" + text + "**")
}


// Emphasis: _text_
func Link( text, url string) {
    buf := getBuffer()
    buf.WriteString("[" + text + "](" + url + ")")
}

// Code writes a code block or inline code to the buffer.
func Code( text string, block bool) {
    buf := getBuffer()
    if block {
        buf.WriteString("\n```\n" + text + "\n```\n")
    } else {
        buf.WriteString("`" + text + "`")
    }
}
