window.location.getQueryParam = (param) ->
  # TODO: (BUG) This code is repeat in dictionay.coffee... fix the
  # loading issue or rewrite when making changes
  #
  p       = param.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex   = new RegExp "[\\?&]" + p + "=([^&#]*)"
  results = regex.exec location.search
  if results is null then "" else decodeURIComponent results[1].replace(/\+/g, " ")
window.location.updateQueryParam = (key,value) ->
  uri = location.search
  re  = new RegExp "([?&])" + key + "=.*?(&|$)", 'i'
  separator = if uri.indexOf('?') isnt -1 then "&" else "?"
  if uri.match re
    if value is null
      return uri.replace re, ''
    else
      return uri.replace re, '$1' + key + "=" + value + '$2'
  else
    return "#{ uri }#{ separator }#{ key }=#{ value }"
