Simple Path Expressions are a dumbed-down but easier-to-use kind of regular expressions for matching and filling paths and urls. For example, `/articles/<year:Y>/<month>/<day>` becomes the regular expression `/^/articles/(\d{4})/([^/]+)/([^/]+)$/`.

## Features

* **Named groups:** simple path expressions returns named groups as objects rather than arrays, making matches easier to work with.
* **Flexible syntax:** Simple Path Expressions support your religious preference. There's <UNIX>, {Python} and :Ruby-style interpolation, and you can specify which one you want to use, or just use them all (the default). [Look at the placeholder definitions](https://github.com/stdbrouw/simple-path-expressions/tree/master/src/placeholders.coffee) to learn more.
* **Shortcuts to common patterns:** specify that a certain URL or path segments needs to be a year or a month or a UUID or a number or a string. [Look at the filter definitions](https://github.com/stdbrouw/simple-path-expressions/tree/master/src/filters.coffee) to learn more.

## How to use

Translate a simple path expression into a regular expression: 

    var simplex = require('simple-path-expressions');
    var route = '/articles/<year>/<month>/<day>';
    var regexp = simplex.compile(route);
    var groups = regexp.exec '/articles/2014/09/01'
    // [ '/articles/2014/09/01', '2014', '09', '01' ]
    console.log(groups);

Match a path against an expression: 

    var url = '/articles/2014/05/04';
    var route = '/articles/<year>/<month>/<day>';
    var match = simplex.match(route, url);
    // { year: '2014', month: '05', day: '05'}
    console.log(match);

Build a path from an expression: 

    var route = '/articles/<year>/<month>/<day>';
    var url = simplex.fill(route, {
        year: 1988, 
        month: '05', 
        day: '04'
    });
    // '/articles/1988/05/04'
    console.log(url);

You can also use a more object-oriented interface with the `PathExp` object.

    var pattern = '/articles/<year>/<month>/<day>';
    var instance = '/articles/2014/05/04';
    var path = new simplex.PathExp(pattern);
    // true
    console.log(path.match(instance) == simplex.match(pattern, instance));

Take a look at the [test suite](https://github.com/stdbrouw/simple-path-expressions/tree/master/test/index.coffee) for more example code.
