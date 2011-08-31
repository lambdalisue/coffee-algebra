assert  = require 'assert'
algebra = require '../src/algebra'

Matrix = algebra.Matrix

factory = ->
    entries = [
        [0, 1, 2]
        [3, 4, 5]
        [6, 7, 8]
        [9, 10, 11]
    ]
    new Matrix entries

exports.testMatrixCreate = (test) ->
    assert.throws ->
        new Matrix [0]
    , /it is not matrix/
    instance = factory()
    assert.deepEqual instance.entries, [[0,1,2], [3,4,5], [6,7,8], [9,10,11]]
    assert.equal instance.m, 4
    assert.equal instance.n, 3
    assert.deepEqual instance.toArray(), [0,1,2,3,4,5,6,7,8,9,10,11]
    assert.equal instance.toString(), "|  0  1  2 |\n|  3  4  5 |\n|  6  7  8 |\n|  9 10 11 |"
    test.done()
exports.testMatrixGet = (test) ->
    instance = factory()
    assert.equal instance.get(0, 0), 0
    assert.equal instance.get(0, 1), 1
    assert.equal instance.get(0, 2), 2
    assert.equal instance.get(1, 0), 3
    assert.equal instance.get(1, 1), 4
    assert.equal instance.get(1, 2), 5
    assert.equal instance.get(2, 0), 6
    assert.equal instance.get(2, 1), 7
    assert.equal instance.get(2, 2), 8
    assert.equal instance.get(3, 0), 9
    assert.equal instance.get(3, 1), 10
    assert.equal instance.get(3, 2), 11

    expected = /is out of range/
    assert.throws ->
        instance.get(-1, 0)
    , expected
    assert.throws ->
        instance.get(0, -1)
    , expected
    assert.throws ->
        instance.get(-1, -1)
    , expected
    assert.throws ->
        instance.get(4, 0)
    , expected
    assert.throws ->
        instance.get(0, 3)
    , expected
    assert.throws ->
        instance.get(4, 3)
    , expected

    assert.equal instance.get(-1, 0, 0), 0
    assert.equal instance.get(0, -1, 0), 0
    assert.equal instance.get(-1, -1, 0), 0
    assert.equal instance.get(4, 0, 0), 0
    assert.equal instance.get(0, 3, 0), 0
    assert.equal instance.get(4, 3, 0), 0
    test.done()
exports.testMatrixSet = (test) ->
    instance = factory()
    instance.set 0, 0, -1
    assert.equal instance.entries[0][0], -1
    instance = factory()
    instance.set 0, 1, -1
    assert.equal instance.entries[0][1], -1
    instance = factory()
    instance.set 0, 2, -1
    assert.equal instance.entries[0][2], -1
    instance = factory()
    instance.set 1, 0, -1
    assert.equal instance.entries[1][0], -1
    instance = factory()
    instance.set 1, 1, -1
    assert.equal instance.entries[1][1], -1
    instance = factory()
    instance.set 1, 2, -1
    assert.equal instance.entries[1][2], -1
    instance = factory()
    instance.set 2, 0, -1
    assert.equal instance.entries[2][0], -1
    instance = factory()
    instance.set 2, 1, -1
    assert.equal instance.entries[2][1], -1
    instance = factory()
    instance.set 2, 2, -1
    assert.equal instance.entries[2][2], -1
    instance = factory()
    instance.set 3, 0, -1
    assert.equal instance.entries[3][0], -1
    instance = factory()
    instance.set 3, 1, -1
    assert.equal instance.entries[3][1], -1
    instance = factory()
    instance.set 3, 2, -1
    assert.equal instance.entries[3][2], -1

    expected = /is out of range/
    assert.throws ->
        instance.set -1, 0, -1
    , expected
    assert.throws ->
        instance.set 0, -1, -1
    , expected
    assert.throws ->
        instance.set -1, -1, -1
    , expected
    assert.throws ->
        instance.set 4, 0, -1
    , expected
    assert.throws ->
        instance.set 0, 3, -1
    , expected
    assert.throws ->
        instance.set 4, 3, -1
    , expected
    test.done()
exports.testMatrixRow = (test) ->
    instance = factory()
    assert.deepEqual instance.row(0), [0, 1, 2]
    assert.deepEqual instance.row(1), [3, 4, 5]
    assert.deepEqual instance.row(2), [6, 7, 8]
    assert.deepEqual instance.row(3), [9, 10, 11]
    test.done()
exports.testMatrixColumn = (test) ->
    instance = factory()
    assert.deepEqual instance.column(0), [0, 3, 6, 9]
    assert.deepEqual instance.column(1), [1, 4, 7, 10]
    assert.deepEqual instance.column(2), [2, 5, 8, 11]
    test.done()
exports.testMatrixIsSquare = (test) ->
    instance = factory()
    assert.ok not instance.isSquare()
    
    entries = [
        [0, 1, 2]
        [3, 4, 5]
        [6, 7, 8]
    ]
    instance = new Matrix entries
    assert.ok instance.isSquare()
    test.done()

exports.testMatrixIsDiagonal = (test) ->
    instance = factory()
    assert.ok not instance.isDiagonal()
    
    entries = [
        [0, 1, 2]
        [3, 4, 5]
        [6, 7, 8]
    ]
    instance = new Matrix entries
    assert.ok not instance.isDiagonal()

    entries = [
        [0, 0, 0]
        [0, 4, 0]
        [0, 0, 8]
    ]
    instance = new Matrix entries
    assert.ok instance.isDiagonal()
    test.done()

exports.testMatrixIsIdentity = (test) ->
    instance = factory()
    assert.ok not instance.isIdentity()
    
    entries = [
        [0, 1, 2]
        [3, 4, 5]
        [6, 7, 8]
    ]
    instance = new Matrix entries
    assert.ok not instance.isIdentity()

    entries = [
        [0, 0, 0]
        [0, 4, 0]
        [0, 0, 8]
    ]
    instance = new Matrix entries
    assert.ok not instance.isIdentity()

    entries = [
        [1, 0, 0]
        [0, 1, 0]
        [0, 0, 1]
    ]
    instance = new Matrix entries
    assert.ok instance.isIdentity()
    test.done()
exports.testMatrixIsSymmetric = (test) ->
    instance = factory()
    assert.ok not instance.isSymmetric()

    # Ref: http://en.wikipedia.org/wiki/Symmetric_matrix
    entries = [
        [1, 7, 3]
        [7, 4, -5]
        [3, -5, 6]
    ]
    instance = new Matrix entries
    assert.ok instance.isSymmetric()
    test.done()
exports.testMatrixIsSkewSymmetric = (test) ->
    instance = factory()
    assert.ok not instance.isSkewSymmetric()

    # Ref: http://en.wikipedia.org/wiki/Skew-symmetric_matrix
    entries = [
        [0, 2, -1]
        [-2, 0, -4]
        [1, 4, 0]
    ]
    instance = new Matrix entries
    assert.ok instance.isSkewSymmetric()
    test.done()
exports.testMatrixCompare = (test) ->
    lhs = factory()
    rhs = factory()

    assert.ok Matrix.compare lhs, rhs
    assert.ok Matrix.compare rhs, lhs
    assert.ok lhs.compare rhs
    assert.ok rhs.compare lhs
    test.done()
exports.testMatrixZero = (test) ->
    zero = Matrix.zero 4, 3
    expected = [
        [0, 0, 0]
        [0, 0, 0]
        [0, 0, 0]
        [0, 0, 0]
    ]
    assert.deepEqual zero.entries, expected
    test.done()
exports.testMatrixIdentify = (test) ->
    identify = Matrix.identify 4
    expected = [
        [1, 0, 0, 0]
        [0, 1, 0, 0]
        [0, 0, 1, 0]
        [0, 0, 0, 1]
    ]
    assert.deepEqual identify.entries, expected
    test.done()
exports.testMatrixPlusError = (test) ->
    lhs = factory()
    rhs = new Matrix [
        [0, 1, 2]
        [3, 4, 5]
        [6, 7, 8]
    ]
    expected = /cannot plus/
    assert.throws -> 
        Matrix.plus lhs, rhs
    , expected
    assert.throws -> 
        Matrix.plus rhs, lhs
    , expected
    assert.throws -> 
        lhs.plus rhs
    , expected
    assert.throws -> 
        rhs.plus lhs
    , expected

    lhs = factory()
    rhs = 2
    expected = /be an instance of/
    assert.throws -> 
        Matrix.plus lhs, rhs
    , expected
    assert.throws -> 
        Matrix.plus rhs, lhs
    , expected
    assert.throws -> 
        lhs.plus rhs
    , expected

    test.done()
exports.testMatrixPlus = (test) ->
    lhs = factory()
    rhs = factory()

    expected = [
        [0, 2, 4]
        [6, 8, 10]
        [12, 14, 16]
        [18, 20, 22]
    ]

    assert.deepEqual Matrix.plus(lhs, rhs).entries, expected
    assert.deepEqual Matrix.plus(rhs, lhs).entries, expected
    assert.deepEqual lhs.plus(rhs).entries, expected
    assert.deepEqual rhs.plus(lhs).entries, expected
    test.done()
exports.testMatrixMinusError = (test) ->
    lhs = factory()
    rhs = new Matrix [
        [0, 1, 2]
        [3, 4, 5]
        [6, 7, 8]
    ]
    expected = /cannot minus/

    assert.throws -> 
        Matrix.minus lhs, rhs
    , expected
    assert.throws -> 
        Matrix.minus rhs, lhs
    , expected
    assert.throws -> 
        lhs.minus rhs
    , expected
    assert.throws -> 
        rhs.minus lhs
    , expected

    lhs = factory()
    rhs = 2
    expected = /be an instance of/
    assert.throws -> 
        Matrix.minus lhs, rhs
    , expected
    assert.throws -> 
        Matrix.minus rhs, lhs
    , expected
    assert.throws -> 
        lhs.minus rhs
    , expected
    test.done()
exports.testMatrixMinus = (test) ->
    lhs = factory()
    rhs = factory()

    expected = [
        [0, 0, 0]
        [0, 0, 0]
        [0, 0, 0]
        [0, 0, 0]
    ]

    assert.deepEqual Matrix.minus(lhs, rhs).entries, expected
    assert.deepEqual Matrix.minus(rhs, lhs).entries, expected
    assert.deepEqual lhs.minus(rhs).entries, expected
    assert.deepEqual rhs.minus(lhs).entries, expected
    test.done()
exports.testMatrixMultipleScalarError = (test) ->
    lhs = factory()
    rhs = "2"
    expected = /unknown object/

    assert.throws -> 
        Matrix.multipleScalar lhs, rhs
    , expected
    assert.throws -> 
        Matrix.multipleScalar rhs, lhs
    , expected
    test.done()
    
exports.testMatrixMultipleScalar = (test) ->
    lhs = factory()
    rhs = 2

    expected = [
        [0, 2, 4]
        [6, 8, 10]
        [12, 14, 16]
        [18, 20, 22]
    ]
    
    assert.deepEqual Matrix.multipleScalar(lhs, rhs).entries, expected
    assert.deepEqual Matrix.multipleScalar(rhs, lhs).entries, expected
    test.done()
exports.testMatrixMultipleMatrixError = (test) ->
    lhs = factory()
    rhs = 2
    expected = /be an instance of/

    assert.throws -> 
        Matrix.multipleMatrix lhs, rhs
    , expected
    assert.throws -> 
        Matrix.multipleMatrix rhs, lhs
    , expected
    
    lhs = factory()
    rhs = factory()
    expected = /cannot multiple/

    assert.throws -> 
        Matrix.multipleMatrix lhs, rhs
    , expected
    assert.throws -> 
        Matrix.multipleMatrix rhs, lhs
    , expected
    test.done()
exports.testMatrixMultipleMatrix = (test) ->
    # Ref: http://en.wikipedia.org/wiki/Matrix_multiplication
    lhs = new Matrix [
        [14, 9, 3]
        [2, 11, 15]
        [0, 12, 17]
        [5, 2, 3]
    ]
    rhs = new Matrix [
        [12, 25]
        [9, 10]
        [8, 5]
    ]
    expected = [
        [273, 455]
        [243, 235]
        [244, 205]
        [102, 160]
    ]
    assert.deepEqual Matrix.multipleMatrix(lhs, rhs).entries, expected
    # Wrong direction will raise exception
    assert.throws -> 
        Matrix.multipleMatrix rhs, lhs
    , /cannot multiple/
    test.done()
exports.testMatrixMultiple = (test) ->
    # Matrix vs Scalar
    lhs = factory()
    rhs = 2

    expected = [
        [0, 2, 4]
        [6, 8, 10]
        [12, 14, 16]
        [18, 20, 22]
    ]
    assert.deepEqual Matrix.multiple(lhs, rhs).entries, expected
    assert.deepEqual Matrix.multiple(rhs, lhs).entries, expected
    assert.deepEqual lhs.multiple(rhs).entries, expected
    
    # Matrix vs Matrix
    lhs = new Matrix [
        [14, 9, 3]
        [2, 11, 15]
        [0, 12, 17]
        [5, 2, 3]
    ]
    rhs = new Matrix [
        [12, 25]
        [9, 10]
        [8, 5]
    ]
    expected = [
        [273, 455]
        [243, 235]
        [244, 205]
        [102, 160]
    ]
    assert.deepEqual Matrix.multiple(lhs, rhs).entries, expected
    assert.throws ->
        Matrix.multiple rhs, lhs
    , /cannot multiple/
    assert.deepEqual lhs.multiple(rhs).entries, expected
    assert.throws ->
        rhs.multiple lhs
    , /cannot multiple/
    test.done()
exports.testMatrixDevideError = (test) ->
    lhs = factory()
    rhs = factory()
    expected = /not defined/

    assert.throws ->
        Matrix.devide lhs, rhs
    , expected
    assert.throws ->
        Matrix.devide rhs, lhs
    , expected
    assert.throws ->
        lhs.devide rhs
    , expected
    assert.throws ->
        rhs.devide lhs
    , expected

    lhs = 2
    rhs = factory()
    expected = /cannot devide/

    assert.throws ->
        Matrix.devide lhs, rhs
    , expected
    test.done()
exports.testMatrixDevide = (test) ->
    lhs = factory()
    rhs = 2
    expected = [
        [0, 0.5, 1]
        [1.5, 2, 2.5]
        [3, 3.5, 4]
        [4.5, 5, 5.5]
    ]

    assert.deepEqual Matrix.devide(lhs, rhs).entries, expected
    assert.deepEqual lhs.devide(rhs).entries, expected
    test.done()
exports.testMatrixPowerError = (test) ->
    notsquare = factory()
    expected = /not defined/
    assert.throws ->
        Matrix.power notsquare, 0
    , expected
    assert.throws ->
        notsquare.power 0
    , expected
    test.done()
exports.testMatrixPower = (test) ->
    square = new Matrix [
        [1, 2, 3]
        [4, 5, 6]
        [7, 8, 9]
    ]
    expected = [
        [1, 0, 0]
        [0, 1, 0]
        [0, 0, 1]
    ]
    k = 0
    assert.deepEqual Matrix.power(square, k).entries, expected
    assert.deepEqual square.power(k).entries, expected

    expected = [
        [1, 2, 3]
        [4, 5, 6]
        [7, 8, 9]
    ]
    k = 1
    assert.deepEqual Matrix.power(square, k).entries, expected
    assert.deepEqual square.power(k).entries, expected

    expected = [
        [30, 36, 42]
        [66, 81, 96]
        [102, 126, 150]
    ]
    k = 2
    assert.deepEqual Matrix.power(square, k).entries, expected
    assert.deepEqual square.power(k).entries, expected

    expected = [
        [468, 576, 684]
        [1062, 1305, 1548]
        [1656, 2034, 2412]
    ]
    k = 3
    assert.deepEqual Matrix.power(square, k).entries, expected
    assert.deepEqual square.power(k).entries, expected

    expected = [
        [7560, 9288, 11016]
        [17118, 21033, 24948]
        [26676, 32778, 38880]
    ]
    k = 4
    assert.deepEqual Matrix.power(square, k).entries, expected
    assert.deepEqual square.power(k).entries, expected
    test.done()
exports.testMatrixResize = (test) ->
    instance = factory()
    expected = [
        [0, 1]
        [3, 4]
    ]
    assert.deepEqual Matrix.resize(instance, 2, 2).entries, expected
    assert.deepEqual instance.resize(2, 2).entries, expected

    expected = [
        [0, 1, 2, 0, 0]
        [3, 4, 5, 0, 0]
        [6, 7, 8, 0, 0]
        [9, 10, 11, 0, 0]
        [0, 0, 0, 0, 0]
        [0, 0, 0, 0, 0]
    ]
    assert.deepEqual Matrix.resize(instance, 6, 5).entries, expected
    assert.deepEqual instance.resize(6, 5).entries, expected
    test.done()
exports.testMatrixTraceError = (test) ->
    instance = factory()
    expected = /not defined/

    assert.throws ->
        Matrix.trace instance
    , expected
    assert.throws ->
        instance.trace()
    , expected
    test.done()
exports.testMatrixTrace = (test) ->
    # Ref: http://en.wikipedia.org/wiki/Matrix_trace
    instance = new Matrix [
        [-2, 2, -3]
        [-1, 1, 3]
        [2, 0, -1]
    ]
    expected = -2

    assert.equal Matrix.trace(instance), expected
    assert.equal instance.trace(), expected
    test.done()
exports.testMatrixTranspose = (test) ->
    instance = factory()
    expected = [
        [0, 3, 6, 9]
        [1, 4, 7, 10]
        [2, 5, 8, 11]
    ]

    assert.deepEqual Matrix.transpose(instance).entries, expected
    assert.deepEqual instance.transpose().entries, expected
    test.done()
exports.testMatrixMinor = (test) ->
    matrix = new Matrix [
        [0, 1, 2, 3, 4, 5]
        [6, 7, 8, 9, 1, 2]
        [3, 4, 5, 6, 7, 8]
        [9, 1, 2, 3, 4, 5]
        [6, 7, 8, 9, 0, 1]
        [2, 3, 4, 5, 6, 7]
        [8, 9, 0, 1, 2, 3]
    ]
    i = 2
    j = 4
    expected = [
        [0, 1, 2, 3, 5]
        [6, 7, 8, 9, 2]
        [9, 1, 2, 3, 5]
        [6, 7, 8, 9, 1]
        [2, 3, 4, 5, 7]
        [8, 9, 0, 1, 3]
    ]
    assert.deepEqual Matrix.minor(matrix, i, j).entries, expected
    test.done()
exports.testMatrixCofactor = (test) ->
    matrix = new Matrix [
        [0, 1, 2, 3, 4, 5]
        [6, 7, 8, 9, 1, 2]
        [3, 4, 5, 6, 7, 8]
        [9, 1, 2, 3, 4, 5]
        [6, 7, 8, 9, 0, 1]
        [2, 3, 4, 5, 6, 7]
        [8, 9, 0, 1, 2, 3]
    ]
    i = 2
    j = 4
    expected = [
        [0, 1, 2, 3, 5]
        [6, 7, 8, 9, 2]
        [9, 1, 2, 3, 5]
        [6, 7, 8, 9, 1]
        [2, 3, 4, 5, 7]
        [8, 9, 0, 1, 3]
    ]
    assert.deepEqual Matrix.cofactor(matrix, i, j).entries, expected
    i = 1
    j = 2
    expected = [
        [-0, -1, -3, -4, -5]
        [-3, -4, -6, -7, -8]
        [-9, -1, -3, -4, -5]
        [-6, -7, -9, -0, -1]
        [-2, -3, -5, -6, -7]
        [-8, -9, -1, -2, -3]
    ]
    assert.deepEqual Matrix.cofactor(matrix, i, j).entries, expected
    test.done()

exports.testMatrixDeterminant = (test) ->
    matrix = new Matrix [
        [1]
    ]
    expected = 1
    assert.equal Matrix.determinant(matrix), expected

    matrix = new Matrix [
        [1, 2]
        [3, 4]
    ]
    expected = -2
    assert.equal Matrix.determinant(matrix), expected

    matrix = new Matrix [
        [0, -2, 0]
        [-1, 3, 1]
        [4, 2, 1]
    ]
    expected = -10
    assert.equal Matrix.determinant(matrix), expected

    matrix = new Matrix [
        [0, -2, 1, 2]
        [2, -3, 0, -1]
        [-1, -2, 1, 1]
        [1, 1, 2, -3]
    ]
    expected = 39
    assert.equal Matrix.determinant(matrix), expected

    a = new algebra.Vector [1, 2]
    b = new algebra.Vector [3, 4]
    console.log a.exterior b

    test.done()
