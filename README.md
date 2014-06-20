## Features

Simple Path Expressions support your religious preference: there's UNIX, Python and Ruby-style interpolation, and you can specify which one you want to use, or just use them all.

There's support for typing, too: specify that a certain URL or path segments needs to be a year or a month or a UUID or a number or a string. [Look at the filter definitions](https://github.com/stdbrouw/simple-path-expressions/tree/master/src/filters.coffee) to learn more.

## How to use

Translate a simple path expression into a regular expression: 

    simplex = require 'simple-path-expressions'
    route = '/articles/<year>/<month>/<day>'
    simplex.compile route

Match a path against an expression: 

    url = '/articles/2014/05/04'
    route = '/articles/<year>/<month>/<day>'
    simplex.match url, route

Build a path from an expression: 

    route = '/articles/<year>/<month>/<day>'
    simplex.fill route
        year: 1988
        month: 05
        day: 04

## Status

This is an alpha release. You probably don't want to use this yet.