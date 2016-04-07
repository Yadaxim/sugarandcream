Object.defineProperty Object.prototype, 'merge',
  enumerable: false
  value: (o) ->
    @[k] = v for k,v of o
    return @
