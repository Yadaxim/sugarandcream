Array::first = ->
  return this[0]
Array::last = ->
  return this[@length - 1]
Array::count = ->
  return @length
Array::empty = ->
  return @length is 0
Array::head = ->
  return this[0]
Array::tail = ->
  return Array::slice.call(this, 1)

Array::clean = ()-> @filter (e)-> e

Array::cleanMap = (fn)-> @map(fn).clean()

Array::transpose = (i, j) ->
  if (@length < i + 1) or (@length < j + 1)
    return this
  tmp = this[i]
  this[i] = this[j]
  this[j] = tmp
  # hacky shmacky...
  @splice @length, 0
  return this
Array::shuffle = ->
  for i in [@length-1..1]
    j = Math.floor Math.random() * (i + 1)
    [this[i], this[j]] = [this[j], this[i]]
  return this
Array::unique = ->
  o = new Object
  for key in [0...@length]
    o[this[key]] = this[key]
  return (value for key, value of o)
Array::uniqueBy = (v) ->
  o = new Object
  for key in [0...@length]
    o[this[key][v]] = this[key]
  value for i, value of o
Array::difference = (a) ->
  @filter (e) -> e not in a

Array::differenceBy = (a, y) ->
  @filter (e) ->
    e[y] not in a.pluck(y)

Array::intersection = (a) ->
  @filter (e) -> e in a

Array::intersectionBy = (a, y) ->
  @filter (e) -> 
    e[y] in a.pluck(y)

Array::union = (a) ->
  @difference(a).concat a

Array::unionBy = (a, y) ->
  @differenceBy(a, y).concat a

Array::humanPrint = (s,y,none) ->
  none = none or undefined
  return none if @length is 0
  return this[0] if @length is 1
  last = @slice(-1)[0]
  head = @slice(0, -1).join "#{ s or ',' } "
  return head + " #{ y or '&' } " + last
# Arrays of Objects

Array::filterBy = (p, v) ->
  @filter (x) -> x[p] is v

Array::firstBy = (p, v) ->
  for e in @
    return e if e[p] is v

Array::firstById = (id) -> @firstBy('id', id)

Array::findFirstByFn = (v, fn) ->
  for e in @
    return e if fn(e) is v

Array::remove = (v) ->
  for e,i in this
    return @splice i,1 if e is v
  return undefined

Array::removeBy = (p, v) ->
  for e,i in this
    return @splice i,1 if e[p] is v
  return undefined


Array::sortBy = (f, r, p) ->
  sb = ->
    if p
      k = (x) -> p(x[f])
    else
      k = (x) -> x[f]

    (i, j) ->
      a = k(i)
      b = k(j)
      [-1, 1][+!!r]*((a>b)-(b>a))

  return @sort sb()

Array::sortByFn = (r, fn) ->
  return @sort (i, j) ->
    a = fn(i)
    b = fn(j)
    [-1, 1][+!!r]*((a>b)-(b>a))


Array::sortByMultiple = (keys) ->
  sb = (k, a, b, r) ->
    r = if r then 1 else -1
    return -1*r if a[k] > b[k]
    return +1*r if a[k] < b[k]
    return 0

  sbm = (a, b , keys) ->
    return r if (r = sb key, a, b) for key in keys
    return 0

  @sort (a, b) -> sbm(a, b, keys)

Array::groupBy = (p) ->
  o = new Object()
  for e in this
    if typeof e[p] is 'undefined'
      throw "AttributeError: Cannot read property \"#{ p }\" of #{ e }"
    else
      if o[e[p]] instanceof Array then o[e[p]].push e
      else o[e[p]] = [e]
  return o

Array::pluck = (p) -> 
  @.map (x)-> 
    x[p]

Array::sum = () -> @reduce(((x, y)->x+y),0)

Array::chunk = (testFn, elementFn, groupFn) ->
  if @length is 0 then return @
  tFn = testFn or ((e) -> e)
  eFn = elementFn or ((e) -> e)
  gFn = groupFn or ((value, array) -> array)
  final = []
  part  = []
  value = null
  last_val = tFn(@first())
  for e in @
    do (e) ->
      value = tFn(e)
      if value is last_val
        part.push eFn(e)
      else
        final.push gFn(last_val, part)
        last_val = value
        part = [eFn(e)]
  final.push gFn(value, part)
  return final

Array::sample = (s=1) -> @shuffle()[..s]

Array::chunkByN = (chunkSize) ->
  array = this
  [].concat.apply [], array.map((elem, i) ->
    (if i % chunkSize then [] else [array.slice(i, i + chunkSize)]))

Array::toObj =  -> @map (n,i) -> {n: n, i: i}


Array::powerset = () ->
  if @length is 0
    [[]]
  else  
    [x,xs...]=@
    ys=xs.powerset()
    result=([x].concat y for y in ys).concat ys

Array::sortedPowerset = (r) -> @.powerset().sortByFn r, (x)->x.length
