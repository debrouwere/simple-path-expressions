simplex = require '../src'


urls = [
    '/:year:Y/(articles/:article?)'
    '/[year]/articles/<article>'
    '/archive/<year>/[month:y]/[day:y]/<author>/index.html'
]


console.log simplex.match '/archive/2014/05/jones/index.html', urls[2]


console.log simplex.fill urls[1], 
    year: 2014
    article: 'hello-world'

console.log simplex.fill urls[1], 
    article: 'hello-world'

console.log simplex.fill urls[1], 
    year: 2014

return

compiled = urls.map (url) -> simplex.compile url

console.log compiled[0].exec '/2014/' # yes
console.log compiled[0].exec '/2014/articles/abc' # yes 
console.log compiled[0].exec '/2014/articles/' # no 
console.log compiled[0].exec '/2014/abc' # no
console.log compiled[1].exec '/2014/articles/abc' # yes 
console.log compiled[1].exec '/articles/abc' # yes 
console.log compiled[2].exec '/archive/2014/05/jones/index.html' # yes 
console.log compiled[2].exec '/archive/2014/jones/index.html' # yes 
