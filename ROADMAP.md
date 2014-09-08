One interesting feature we might implement at one point would be filters.

	/articles/{month|lowercase}/{title|slugify}/

The concept is pretty similar to how filters work in Jinja or Liquid templates: when you do `expression.fill` it will first process the variable `month` with a `lowercase` function before filling it in.

Formats determine what input to a path expression should look like to make a match. Filters determine what the output from a path expression should look like, given an object that contains values to fill in the placeholders.

That said, I suppose we could also support filters on input, which would post-process a match, e.g.

	/articles/{year:Y|integer}
	
The main use-case I have in mind is not usage in routers, but usage in a move user-friendly version of the linux `rename` utility.