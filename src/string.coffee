String::toBoolean = ->
  if @valueOf() is "true"
    return true
  else if @valueOf() is "false"
    return false
  else
    return undefined

String::closest_in = (a,d) ->
  if not (utils? or utils.levenshtein?)
    throw Error "utils.levenshtein is not defined"
  a.filter (e) => (utils.levenshtein @, e) <= d

String::capitalise = ->
  return @charAt(0).toUpperCase() + @slice(1)

String::regExpEscape = ->
  @replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'

String::format = (args...) ->
  s = @
  i = args.length
  while i
    i -= 1
    re = new RegExp "\\{#{ i }\\}", 'gm'
    s  = s.replace re, args[i]
  return s

String::camelise = ->
  @replace /(?:^|[-_])(\w)/g, (_,c) ->
    if c then c.toUpperCase() else ""
    
String::startsWith = (sub)->
  @lastIndexOf(sub,0) is 0


String::truncate = (l) -> if string.length > l then string[0..l] + "..." else string
