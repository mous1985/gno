package markdown

import "strings"

// this package can be used to test markdown rendering engines.

func Render(path string) string {
	output := `# Markdown on Gno

## Introduction

Markdown on Gno is based on standard markdown, but also has some unique features, making it the Gno Flavored Markdown. This document describes the current markdown support in Gno, demonstrating both the syntax and its rendered output.

> [!NOTE]
> Markdown support in Gno is still evolving. New features and improvements will be added in future releases.

## Basic Syntax

### Headings

Headings are created using hash symbols (#). The number of hash symbols indicates the heading level.

±±±markdown
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
±±±

# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6

### Text Formatting

You can format text using the following syntax:

±±±markdown
**Bold text**
*Italic text*
~~Strikethrough text~~
**Bold and _nested italic_**
***All bold and italic***
±±±

**Bold text**  
*Italic text*  
~~Strikethrough text~~  
**Bold and _nested italic_**  
***All bold and italic***  

### Links

Links can be created using the following syntax:

±±±markdown
[Link text](https://example.com)
[Link with title](https://example.com "Link title")
±±±

[Link text](https://example.com)  
[Link with title](https://example.com "Link title")

XXX: custom CSS for internal/external links and if possible for "in the same realm/namespace".

### Lists

Unordered lists use asterisks, plus signs, or hyphens:

±±±markdown
* Item 1
* Item 2
  * Nested item 1
  * Nested item 2
±±±

* Item 1
* Item 2
  * Nested item 1
  * Nested item 2

Ordered lists use numbers:

±±±markdown
1. First item
2. Second item
   1. Nested item 1
   2. Nested item 2
±±±

1. First item
2. Second item
   1. Nested item 1
   2. Nested item 2

### Blockquotes

Blockquotes are created using the > character:

±±±markdown
> This is a blockquote
> 
> It can span multiple lines
±±±

> This is a blockquote
> 
> It can span multiple lines

### Code

Inline code uses single backticks:

±±±markdown
Use ±func main()± to define the entry point.
±±±

Use ±func main()± to define the entry point.

Code blocks use triple backticks with an optional language identifier:

<!-- XXX: make the example with 'gno' instead of 'go' -->

±±±markdown
±±±go
package main

func main() {
    println("Hello, Gno!")
}
±±±

±±±go
package main

func main() {
    println("Hello, Gno!")
}
±±±

### Horizontal Rules

Horizontal rules are created using three or more asterisks, hyphens, or underscores:

±±±markdown
---
±±±

---

<!-- XXX: add again this feature that was removed -->
<!--
### Task Lists

Gno supports task lists for tracking to-do items:

±±±markdown
- [x] Completed task
- [ ] Pending task
±±±

- [x] Completed task
- [ ] Pending task
-->

## Tables

Tables are created using pipes and hyphens:

±±±markdown
| Header 1 | Header 2 |
| -------- | -------- |
| Cell 1   | Cell 2   |
| Cell 3   | Cell 4   |
±±±

| Header 1 | Header 2 |
| -------- | -------- |
| Cell 1   | Cell 2   |
| Cell 3   | Cell 4   |

## Images

Images can be included using the following syntax:

±±±markdown
![Alt text](/public/imgs/gnoland.svg "Optional title")
±±±

![Alt text](/public/imgs/gnoland.svg "Optional title")

## Gno-Specific Features

### HTML Support

By design, most typical HTML support is disabled in Gno's markdown implementation. This is an intentional decision for both security and ecosystem cohesion.

While traditional markdown often allows arbitrary HTML tags, Gno Flavored Markdown takes a more controlled approach:

- We may progressively whitelist certain HTML components or add custom ones over time
- Our priority is to enhance our flavored markdown to natively support all essential components
- We aim to eventually support all the initially HTML-supported features, but with syntax that is:
  - More readable when viewing the source directly
  - More integrable with custom browsers such as gnobro in CLI

This approach allows for a more consistent rendering experience across different Gno interfaces while maintaining security and readability as core principles.

### Columns

XXX: in progress in https://github.com/gnolang/gno/pull/3763

### Usernames

XXX: TODO (add again this feature that was removed)

<!--
±±±markdown
@username
@dev123
±±±

@username
@dev123
-->

### Bech32 Addresses

XXX: TODO

Gno markdown can automatically recognize and render Bech32 addresses.

±±±markdown
g1jg955hm9a6f0yen878c2hur6q7stqz7rzpyrwpe
±±±

g1jg955hm9a6f0yen878c2hur6q7stqz7rzpyrwpe

### Smart Contract Integration

XXX: TODO

±±±markdown
gno.land/r/boards
gno.land/r/boards:foo/bar
gno.land/r/docs/markdown$source
±±±

gno.land/r/boards
gno.land/r/boards:foo/bar
gno.land/r/docs/markdown$source

### And more...

XXX: TODO

## Future Enhancements

The markdown support in Gno is being actively developed. Future enhancements may include:

- Extended support for custom components
- Interactive elements specific to blockchain functions
- Rich rendering of on-chain data
- Better integration with Gno's package system

[Read more](https://github.com/gnolang/gno/issues/3255)

## Conclusion

Markdown on Gno provides a familiar syntax for developers who have experience with GitHub Flavored Markdown, while adding blockchain-specific extensions that make it more powerful in the context of the Gno platform.

As the Gno ecosystem grows, expect the markdown capabilities to expand accordingly, providing even richer formatting and interactive elements for documentation and user interfaces.
`
	output = strings.ReplaceAll(output, "±", "`")
	return output
}
