assert  = require 'assert'
algebra = require '../src/algebra'

Vector = algebra.Vector

factory = ->
    new Vector 0, 1, 2, 3

exports.testVectorCreate = (test) ->
    assert.throws ->
        new Vector 0
    , /it is not vector/
    vector = new Vector 1, 2, 3
    assert.deepEqual vector.values, [1, 2, 3]
    assert.equal vector.m, 1
    assert.equal vector.n, 3
    assert.equal vector.dimension, 3
    vector = new Vector [1, 2, 3]
    assert.deepEqual vector.values, [1, 2, 3]
    assert.equal vector.m, 1
    assert.equal vector.n, 3
    assert.equal vector.dimension, 3
    test.done()
exports.testVectorGet = (test) ->
    vector = factory()
    assert.equal vector.get(0), 0
    assert.equal vector.get(1), 1
    assert.equal vector.get(2), 2
    assert.equal vector.get(3), 3
    assert.equal vector.get(0, 0), 0
    assert.equal vector.get(0, 1), 1
    assert.equal vector.get(0, 2), 2
    assert.equal vector.get(0, 3), 3
    test.done()
exports.testVectorSet = (test) ->
    vector = factory()
    vector.set 0, -1
    assert.equal vector.values[0], -1
    vector = factory()
    vector.set(1, -1)
    assert.equal vector.values[1], -1
    vector = factory()
    vector.set(2, -1)
    assert.equal vector.values[2], -1
    vector = factory()
    vector.set(3, -1)
    assert.equal vector.values[3], -1
    vector = factory()
    vector.set(0, 0, -1)
    assert.equal vector.values[0], -1
    vector = factory()
    vector.set(0, 1, -1)
    assert.equal vector.values[1], -1
    vector = factory()
    vector.set(0, 2, -1)
    assert.equal vector.values[2], -1
    vector = factory()
    vector.set(0, 3, -1)
    assert.equal vector.values[3], -1
    test.done()
exports.testVectorXYZGet = (test) ->
    vector = new Vector 1, 2
    assert.equal vector.x, 1
    assert.equal vector.y, 2
    assert.throws ->
        vector.z
    , /not available/
    vector = new Vector 1, 2, 3
    assert.equal vector.x, 1
    assert.equal vector.y, 2
    assert.equal vector.z, 3
    vector = new Vector 1, 2, 3, 4
    assert.throws ->
        vector.x
    , /not available/
    assert.throws ->
        vector.y
    , /not available/
    assert.throws ->
        vector.z
    , /not available/
    test.done()
exports.testVectorXYZSet = (test) ->
    vector = new Vector 1, 2
    vector.x = -1
    assert.equal vector.values[0], -1
    vector = new Vector 1, 2
    vector.y = -1
    assert.equal vector.values[1], -1
    vector = new Vector 1, 2
    assert.throws ->
        vector.z = -1
    , /not available/
    vector = new Vector 1, 2, 3
    vector.x = -1
    assert.equal vector.values[0], -1
    vector = new Vector 1, 2, 3
    vector.y = -1
    assert.equal vector.values[1], -1
    vector = new Vector 1, 2, 3
    vector.z = -1
    assert.equal vector.values[2], -1
    vector = new Vector 1, 2, 3, 4
    assert.throws ->
        vector.x = -1
    , /not available/
    vector = new Vector 1, 2, 3, 4
    assert.throws ->
        vector.y = -1
    , /not available/
    vector = new Vector 1, 2, 3, 4
    assert.throws ->
        vector.z = -1
    , /not available/
    test.done()
exports.testVectorDotError = (test) ->
    lhs = factory()
    rhs = 1
    expected = /be an instance of Vector/

    assert.throws ->
        Vector.dot lhs, rhs
    , expected
    assert.throws ->
        Vector.dot rhs, lhs
    , expected
    assert.throws ->
        lhs.dot rhs
    , expected

    lhs = factory()
    rhs = new Vector 1, 2, 3
    expected = /cannot dot product/

    assert.throws ->
        Vector.dot lhs, rhs
    , expected
    assert.throws ->
        Vector.dot rhs, lhs
    , expected
    assert.throws ->
        rhs.dot lhs
    , expected
    assert.throws ->
        lhs.dot rhs
    , expected

    test.done()

exports.testVectorDot = (test) ->
    # Ref: http://en.wikipedia.org/wiki/Dot_product
    lhs = new Vector 1, 3, -5
    rhs = new Vector 4, -2, -1
    expected = 3

    assert.equal Vector.dot(lhs, rhs), expected
    assert.equal lhs.dot(rhs), expected

    test.done()
exports.testVectorCrossError = (test) ->
    lhs = factory()
    rhs = 1
    expected = /be an instance of Vector/

    assert.throws ->
        Vector.cross lhs, rhs
    , expected
    assert.throws ->
        Vector.cross rhs, lhs
    , expected
    assert.throws ->
        lhs.cross rhs
    , expected

    lhs = factory()
    rhs = new Vector 1, 2, 3
    expected = /cannot cross product/

    assert.throws ->
        Vector.cross lhs, rhs
    , expected
    assert.throws ->
        Vector.cross rhs, lhs
    , expected
    assert.throws ->
        rhs.cross lhs
    , expected
    assert.throws ->
        lhs.cross rhs
    , expected

    lhs = new Vector 1, 2, 3, 4
    rhs = new Vector 1, 2, 3, 4
    expected = /not defined/

    assert.throws ->
        Vector.cross lhs, rhs
    , expected
    assert.throws ->
        Vector.cross rhs, lhs
    , expected
    assert.throws ->
        rhs.cross lhs
    , expected
    assert.throws ->
        lhs.cross rhs
    , expected

    test.done()
exports.testVectorCross = (test) ->
    lhs = new Vector 1, 2, 3
    rhs = new Vector 4, 5, 6
    expected = [-3, 6, -3]

    assert.deepEqual Vector.cross(lhs, rhs).values, expected
    assert.deepEqual lhs.cross(rhs).values, expected

    expected = [3, -6, 3]
    assert.deepEqual Vector.cross(rhs, lhs).values, expected
    assert.deepEqual rhs.cross(lhs).values, expected

    test.done()
exports.testVectorOuterError = (test) ->
    lhs = factory()
    rhs = 1
    expected = /be an instance of Vector/

    assert.throws ->
        Vector.outer lhs, rhs
    , expected
    assert.throws ->
        Vector.outer rhs, lhs
    , expected
    assert.throws ->
        lhs.outer rhs
    , expected

    test.done()
exports.testVectorOuter = (test) ->
    lhs = new Vector 1, 2, 3
    rhs = new Vector 4, 5, 6, 7

    # lhs x rhs (forward)
    expected = [
        [4, 5, 6, 7]
        [8, 10, 12, 14]
        [12, 15, 18, 21]
    ]
    result = Vector.outer lhs, rhs
    assert.ok result instanceof algebra.Matrix
    assert.ok result not instanceof Vector
    assert.equal result.m, 3
    assert.equal result.n, 4
    assert.deepEqual result.entries, expected
    assert.deepEqual lhs.outer(rhs).entries, expected

    # rhs x lhs (reverse)
    expected = [
        [4, 8, 12]
        [5, 10, 15]
        [6, 12, 18]
        [7, 14, 21]
    ]
    result = Vector.outer rhs, lhs
    assert.ok result instanceof algebra.Matrix
    assert.ok result not instanceof Vector
    assert.equal result.m, 4
    assert.equal result.n, 3
    assert.deepEqual result.entries, expected
    assert.deepEqual rhs.outer(lhs).entries, expected

    test.done()
exports.testVectorExteriorError = (test) ->
    lhs = factory()
    rhs = 1
    expected = /be an instance of Vector/

    assert.throws ->
        Vector.exterior lhs, rhs
    , expected
    assert.throws ->
        Vector.exterior rhs, lhs
    , expected
    assert.throws ->
        lhs.exterior rhs
    , expected

    lhs = factory()
    rhs = new Vector 1, 2, 3
    expected = /cannot exterior product/

    assert.throws ->
        Vector.exterior lhs, rhs
    , expected
    assert.throws ->
        Vector.exterior rhs, lhs
    , expected
    assert.throws ->
        lhs.exterior rhs
    , expected
    assert.throws ->
        rhs.exterior lhs
    , expected

    test.done()

exports.testVectorExterior = (test) ->
    lhs = new Vector 1, 2, 3
    rhs = new Vector 4, 5, 6

    expected = [
        [0, -3, -6]
        [3, 0, -3]
        [6, 3, 0]
    ]
    result = Vector.exterior lhs, rhs
    assert.ok result instanceof algebra.Matrix
    assert.ok result not instanceof Vector
    assert.equal result.m, 3
    assert.equal result.n, 3
    assert.deepEqual result.entries, expected
    assert.deepEqual lhs.exterior(rhs).entries, expected

    test.done()
