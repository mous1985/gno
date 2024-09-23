package myui

import (
    "bytes"
    
    
)

type Context struct {
	buf *bytes.Buffer
}

func NewContext() *Context {
	return &Context{
		buf: &bytes.Buffer{},
	}
}

func (ctx *Context) String() string {
	return ctx.buf.String()
}