$.each ["put", "del"], (a,b) ->
  $[b] = (a,c,d,e) ->
    b = "delete" if b is "del"
    $.isFunction(c) and (
      e = e or d
      d = c
      c = undefined )
    $.ajax
      url: a
      type: b
      dataType: e
      data: c
      success: d
