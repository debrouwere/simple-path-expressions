simplex = require '../src'

describe 'simplex', ->
    it 'can run a test suite', ->
        yes

    it 'can select from multiple kinds of placeholders', ->
        placeholders = simplex.placeholders.get()
        placeholders.required.length.should.equal 3
        placeholders.optional.length.should.equal 3
        placeholders = simplex.placeholders.get 'ruby'
        placeholders.required.length.should.equal 1
        placeholders.optional.length.should.equal 1

    it 'can check whether a format has placeholders or not', ->
        some = simplex.compile '/articles/:date/:article'
        none = simplex.compile '/articles'

        some.hasPlaceholders.should.equal yes
        none.hasPlaceholders.should.equal no