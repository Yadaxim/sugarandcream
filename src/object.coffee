Object.defineProperty Object.prototype, 'merge',
  enumerable: false
  value: (o) ->
    @[k] = v for k,v of o
    return @


Object.defineProperty Object.prototype, 'pick',
  enumerable: false
  value: (arr) ->
    obj = {}
    obj[k] = @[k] for k in arr
    return obj


Object.defineProperty Object.prototype, 'omit',
  enumerable: false
  value: (arr) ->
    obj = {}
    (obj[k] = v unless k in arr) for k, v of @
    return obj