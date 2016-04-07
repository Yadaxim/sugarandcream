$.md5 = md5
$.fn.toObject = (param = 'name') ->
  o = new Object
  @find("[#{ param }]").each (i,e) ->
    $e = $(e)
    a  = $e.attr param
    o[a] =
      switch $e.attr 'type'
        when 'password' then $.md5 $e.val()
        when 'checkbox' then $e.is ':checked'
        when 'number'   then + $e.val()
        else $e.val()
    return true
  return o
$.fn.fillIn = (e, a = 'name') ->
  @find('input, textarea').each (i,input) ->
    atr = $(input).attr(a)
    if atr and e[atr] then $(input).val e[atr]
  return @
