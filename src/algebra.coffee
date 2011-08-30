class AccessorPropertyObject
    # Ref: https://github.com/jashkenas/coffee-script/issues/1039
    @get: (propertyName, func) ->
        Object.defineProperty @::, propertyName,
            configurable: true
            enumerable: true
            get: func
    @set: (propertyName, func) ->
        Object.defineProperty @::, propertyName,
            configurable: true
            enumerable: true
            set: func

sum = (a) ->
    if a.length is 0 then return 0
    a.reduce (lhs, rhs) -> (lhs + rhs)
max = (a) ->
    if a.length is 0 then return 0
    a.reduce (lhs, rhs) -> Math.max lhs, rhs
flatten = (a) ->
    if a.length is 0 then return []
    a.reduce (lhs, rhs) -> lhs.concat rhs
pad = (str, n, letter=0) ->
    offset = n - str.toString().length
    if offset > 0
        leading = Array(offset+1).join letter
        "#{leading}#{str}"
    else
        str

exports.Matrix = class Matrix extends AccessorPropertyObject
    constructor: (entries) ->
        if entries.length is 1 and entries[0] not instanceof Array
            throw new Error "it is not matrix but scalar"
        @_entries = entries

    @get 'entries', -> @_entries
    @get 'm', -> @entries.length        # Height (The number of rows)
    @get 'n', -> @entries[0].length     # Width (The number of columns)

    get: (i, j, def=null) -> 
        if 0 <= i < @m and 0 <= j < @n
            return @entries[i][j]
        else if def?
            return def
        else
            throw new Error "error: (#{i}, #{j}) is out of range."
    set: (i, j, value) -> 
        if 0 <= i < @m and 0 <= j < @n
            @entries[i][j] = value
        else
            throw new Error "error: (#{i}, #{j}) is out of range."

    row: (i) -> @entries[i]
    column: (j) -> (row[j] for row in @entries)

    # Return an one-dimensional array
    toArray: -> flatten @entries
    # Return human readable string
    toString: ->
        # find longest length of entries
        longest = (max @toArray()).toString().length

        rows = []
        for row in @entries
            prow = (pad(e, longest, ' ') for e in row)
            rows.push "| #{prow.join ' '} |"
        return rows.join '\n'

    isSquare: -> @m is @n
    isDiagonal: ->
        if not @isSquare() then return false
        for i in [0...@m]
            for j in [0...@n]
                if i is j then continue
                if @get(i, j) isnt 0 then return false
        return true
    isIdentity: ->
        if not (@isSquare() and @isDiagonal()) then return false
        for i in [0...@m]
            if @get(i, i) isnt 1 then return false
        return true
    isSymmetric: ->
        transpose = @transpose()
        @compare transpose
    isSkewSymmetric: ->
        transpose = @transpose()
        @compare transpose.multiple -1

    compare: (matrix) ->
        Matrix.compare @, matrix
    @compare: (lhs, rhs) ->
        if lhs.m isnt rhs.m or lhs.n isnt rhs.n
            return false
        for i in [0...lhs.m]
            for j in [0...lhs.n]
                if lhs.get(i, j) isnt rhs.get(i, j) then return false
        return true
    plus: (rhs) ->
        Matrix.plus @, rhs
    @plus: (lhs, rhs) ->
        if lhs not instanceof Matrix or rhs not instanceof Matrix
            throw new Error "error: lhs and rhs must be an instance of Matrix"
        else if lhs.m isnt rhs.m or lhs.n isnt rhs.n
            throw new Error "error: cannot plus two matrix which has different type"
        newMatrix = []
        for i in [0...lhs.m]
            row = []
            for j in [0...lhs.n]
                row.push(lhs.get(i,j) + rhs.get(i,j))
            newMatrix.push row
        new Matrix newMatrix
    minus: (rhs) ->
        Matrix.minus @, rhs
    @minus: (lhs, rhs) ->
        if lhs not instanceof Matrix or rhs not instanceof Matrix
            throw new Error "error: lhs and rhs must be an instance of Matrix"
        if lhs.m isnt rhs.m or lhs.n isnt rhs.n
            throw new Error "error: cannot minus two matrix which has different type"
        newMatrix = []
        for i in [0...lhs.m]
            row = []
            for j in [0...lhs.n]
                row.push(lhs.get(i,j) - rhs.get(i,j))
            newMatrix.push row
        new Matrix newMatrix
    @multipleScalar: (lhs, rhs) ->
        if lhs instanceof Matrix and typeof rhs is "number"
            matrix = lhs
            scalar = rhs
        else if rhs instanceof Matrix and typeof lhs is "number"
            matrix = rhs
            scalar = lhs
        else
            throw new Error "error: unknown object has passed"
        newMatrix = []
        for i in [0...matrix.m]
            row = []
            for j in [0...matrix.n]
                row.push(matrix.get(i,j) * scalar)
            newMatrix.push row
        new Matrix newMatrix
    @multipleMatrix: (lhs, rhs) ->
        if lhs not instanceof Matrix or rhs not instanceof Matrix
            throw new Error "error: lhs and rhs must be an instance of Matrix"
        if lhs.n isnt rhs.m
            throw new Error "error: cannot multiple this two matrix. only matrix pair of M x N and N x L is defined"
        newMatrix = []
        for i in [0...lhs.m]
            row = []
            for j in [0...rhs.n]
                row.push sum(lhs.get(i,k)*rhs.get(k,j) for k in [0...lhs.n])
            newMatrix.push row
        new Matrix newMatrix
    multiple: (rhs) ->
        Matrix.multiple @, rhs
    @multiple: (lhs, rhs) ->
        if typeof lhs isnt "number" and typeof rhs isnt "number"
            return @multipleMatrix lhs, rhs
        return @multipleScalar lhs, rhs
    devide: (rhs) ->
        Matrix.devide @, rhs
    @devide: (lhs, rhs) ->
        if lhs instanceof Matrix and rhs instanceof Matrix
            throw new Error "error: devision of two matrix is not defined"
        if typeof rhs isnt "number"
            throw new Error "error: you cannot devide scalar with matrix"
        newMatrix = []
        for i in [0...lhs.m]
            row = []
            for j in [0...lhs.n]
                row.push(lhs.get(i,j) / rhs)
            newMatrix.push row
        new Matrix newMatrix
    power: (k) ->
        Matrix.power @, k
    @power: (matrix, k) ->
        if not matrix.isSquare()
            throw new Error "error: a power of matrix is not defined except square matrix"
        switch k
            when 0 then return Matrix.identify matrix.m
            when 1 then return matrix
            when 2 then return matrix.multiple matrix
            else
                matrix.multiple matrix.power k-1
    resize: (m, n) ->
        Matrix.resize @, m, n
    @resize: (matrix, m, n) ->
        newMatrix = []
        for i in [0...m]
            row = []
            for j in [0...n]
                row.push matrix.get(i,j, 0)
            newMatrix.push row
        new Matrix newMatrix
    trace: ->
        Matrix.trace @
    @trace: (matrix) ->
        # Return trace of square matrix
        if not matrix.isSquare()
            throw new Error "error: trace of non square matrix is not defined"
        sum(matrix.get(i, i) for i in [0...matrix.m])
    transpose: ->
        Matrix.transpose @
    @transpose: (matrix) ->
        # Return transpose matrix
        newMatrix = []
        for j in [0...matrix.n]
            row = []
            for i in [0...matrix.m]
                row.push matrix.get(i, j)
            newMatrix.push row
        new Matrix newMatrix


    minor: (i, j) ->
        Matrix.minor @, i, j
    @minor: (matrix, i, j) ->
        newMatrix = []
        for k in [0...i]
            row = []
            for m in [0...j]
                row.push matrix.get(k, m)
            for m in [j+1...matrix.n]
                row.push matrix.get(k, m)
            newMatrix.push row
        for k in [i+1...matrix.m]
            row = []
            for m in [0...j]
                row.push matrix.get(k, m)
            for m in [j+1...matrix.n]
                row.push matrix.get(k, m)
            newMatrix.push row
        new Matrix newMatrix
    cofactor: (i, j) ->
        Matrix.cofactor @, i, j
    @cofactor: (matrix, i, j) ->
        flag = Math.pow -1, (i+j)
        # Matrix.minor(matrix, i, j).multiple flag
        newMatrix = []
        for k in [0...i]
            row = []
            for m in [0...j]
                row.push flag * matrix.get(k, m)
            for m in [j+1...matrix.n]
                row.push flag * matrix.get(k, m)
            newMatrix.push row
        for k in [i+1...matrix.m]
            row = []
            for m in [0...j]
                row.push flag * matrix.get(k, m)
            for m in [j+1...matrix.n]
                row.push flag * matrix.get(k, m)
            newMatrix.push row
        new Matrix newMatrix
    determinant: ->
        Matrix.determinant @
    @determinant: (matrix) ->
        if not matrix.isSquare()
            throw new Error "determinant of non square matrix is not defined"
        switch matrix.m
            when 1 then return matrix.get(0, 0)
            when 2
                return matrix.get(0, 0)*matrix.get(1, 1)-matrix.get(0, 1)*matrix.get(1, 0)
            when 3
                a = matrix.get(0,0)*matrix.get(1,1)*matrix.get(2,2)
                b = matrix.get(0,1)*matrix.get(1,2)*matrix.get(2,0)
                c = matrix.get(0,2)*matrix.get(1,0)*matrix.get(2,1)
                d = matrix.get(0,2)*matrix.get(1,1)*matrix.get(2,0)
                e = matrix.get(0,1)*matrix.get(1,0)*matrix.get(2,2)
                f = matrix.get(0,0)*matrix.get(1,2)*matrix.get(2,1)
                return a+b+c-d-e-f
            else
                factor = (i, j) ->
                    entry = matrix.get i, j
                    cofactor = matrix.cofactor i, j
                    return entry * cofactor.determinant()
                return sum(factor(i, 0) for i in [0...matrix.m])
        
    @zero: (m, n) ->
        # Return zero matrix
        newMatrix = []
        for j in [0...m]
            row = []
            for i in [0...n]
                row.push 0
            newMatrix.push row
        new Matrix newMatrix
    @identify: (m) ->
        matrix = Matrix.zero m, m
        for i in [0...m]
            matrix.set i, i, 1
        matrix
exports.Vector = class Vector extends Matrix
    constructor: (entries...) ->
        # for convinience, you can create new Vector with
        # the syntax below
        # 
        #   1. vector = Vector 0, 1, 2
        #   2. vector = Vector [0, 1, 2]
        #
        if entries.length is 1 and entries[0] instanceof Array
            entries = entries[0]
        else if entries.length is 1
            throw new Error "error: it is not vector but scalar"
        super [entries]

    @get 'values', -> @row(0)
    @get 'dimension', -> @n

    # for convinience, now get and set function has default i
    get: (i, j, def=null) ->
        if arguments.length is 1
            j = i
            i = 0
        super i, j, def
    set: (i, j, value=null) ->
        if arguments.length is 2
            value = j
            j = i
            i = 0
        super i, j, value

    # for convinience, you can access entries with attribute
    # 'x', 'y' and 'z' if dimension is 2 or 3
    @get 'x', -> 
        if @dimension <= 3
            return @get(0)
        throw new Error "error: shortcut property is not available on this vector"
    @get 'y', -> 
        if @dimension <= 3
            return @get(1)
        throw new Error "error: shortcut property is not available on this vector"
    @get 'z', ->
        if @dimension is 3
            return @get(2)
        throw new Error "error: shortcut property is not available on this vector"
    @set 'x', (value) -> 
        if @dimension <= 3
            @set(0, value)
        else
            throw new Error "error: shortcut property is not available on this vector"
    @set 'y', (value) -> 
        if @dimension <= 3
            @set(1, value)
        else
            throw new Error "error: shortcut property is not available on this vector"
    @set 'z', (value) ->
        if @dimension is 3
            @set(2, value)
        else
            throw new Error "error: shortcut property is not available on this vector"


    dot: (rhs) ->
        Vector.dot @, rhs
    cross: (rhs) ->
        Vector.cross @, rhs
    outer: (rhs) ->
        Vector.outer @, rhs
    exterior: (rhs) ->
        Vector.exterior @, rhs

    @dot: (lhs, rhs) ->
        if lhs not instanceof Vector or rhs not instanceof Vector
            throw new Error "error: lhs and rhs must be an instance of Vector for dot product"
        else if lhs.dimension isnt rhs.dimension
            throw new Error "error: cannot dot product between two different dimensional vector"
        sum(lhs.get(i)*rhs.get(i) for i in [0...lhs.dimension])
        # Code that using transpose method is below
        # result = lhs.multiple rhs.transpose()
        # return result.get(0, 0)

    @cross: (lhs, rhs) ->
        if lhs not instanceof Vector or rhs not instanceof Vector
            throw new Error "error: lhs and rhs must be an instance of Vector for cross product"
        else if lhs.dimension isnt rhs.dimension
            throw new Error "error: cannot cross product between two different dimensional vector"
        else if lhs.dimension > 3
            throw new Error "error: cross product is not defined except the dimension of vector is 3"
        new Vector lhs.y*rhs.z-lhs.z*rhs.y, lhs.z*rhs.x-lhs.x*rhs.z, lhs.x*rhs.y-lhs.y*rhs.x
        
    @outer: (lhs, rhs) ->
        if lhs not instanceof Vector or rhs not instanceof Vector
            throw new Error "error: lhs and rhs must be an instance of Vector for outer product"
        newMatrix = []
        for i in [0...lhs.dimension]
            row = []
            for j in [0...rhs.dimension]
                row.push lhs.get(i)*rhs.get(j)
            newMatrix.push row
        new Matrix newMatrix
        # Code that using transpose method is below
        # return lhs.transpose().multiple rhs
    @exterior: (lhs, rhs) ->
        if lhs not instanceof Vector or rhs not instanceof Vector
            throw new Error "error: lhs and rhs must be an instance of Vector for exterior product"
        else if lhs.dimension isnt rhs.dimension
            throw new Error "error: cannot exterior product between two different dimensional vector"
        newMatrix = []
        for i in [0...lhs.dimension]
            row = []
            for j in [0...rhs.dimension]
                row.push lhs.get(i)*rhs.get(j) - rhs.get(i)*lhs.get(j)
            newMatrix.push row
        new Matrix newMatrix
        # Code that using outer method is below
        # lhs.outer(rhs).minus rhs.outer lhs
