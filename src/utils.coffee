utils =
  fnRun: (f,args...) ->
    if typeof f is 'function' then f.apply undefined, args
  levenshtein: (s,t) ->
    m = s.length
    n = t.length
    return n if m is 0
    return m if n is 0
    d = new Array
    for i in [0..m]
      row = []
      row.push 0 for j in [0..n]
      d.push row
    d[i][0] = i for i in [1..m]
    d[0][j] = j for j in [1..n]
    for j in [1..n]
      for i in [1..m]
        if s[i-1] is t[j-1] then d[i][j] = d[i-1][j-1]
        else d[i][j] = Math.min (d[i-1][j]+1), (d[i][j-1]+1), (d[i-1][j-1]+1)
    return d[m][n]
  charRange: (start, stop) ->
    result = []
    idx = start.charCodeAt(0)
    end = stop.charCodeAt(0)
    while idx <= end
      result.push String.fromCharCode(idx)
      ++idx
    result
if global? then global.utils = utils
if window? then window.utils = utils
