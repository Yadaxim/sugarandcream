Date::prettyHTML = (weekdays, months) ->
  weekdays = weekdays or ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  months   = months or ['January', 'February', 'Mach', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  d = new Date @getTime() + (@getTimezoneOffset() * 60000)
  month   = months[d.getMonth()]
  day     = if d.getDate() < 10 then "&nbsp;#{ d.getDate() }" else "#{ d.getDate() }"
  year    = d.getFullYear()
  weekday = weekdays[d.getDay()].substr(0,3)
  return "<span style='font-family: monospace'>
    #{ month } #{ day }, #{ year } <span style='color: #aaaaaa'>(#{ weekday })</span>
    </span>"
Date::standardDate = ->
  # this < 9 might look weird, it's correct.
  #
  month = if @getMonth() < 9  then "0#{ @getMonth() + 1 }" else "#{ @getMonth() + 1 }"
  day   = if @getDate()  < 10 then "0#{ @getDate() }"      else "#{ @getDate() }"
  year  = @getFullYear()
  return "#{ year }-#{ month }-#{ day }"
Date::standardDateTime = ->
  # this < 9 might look weird, it's correct.
  #
  month   = if @getMonth()   < 9  then "0#{ @getMonth() + 1 }" else "#{ @getMonth() + 1 }"
  day     = if @getDate()    < 10 then "0#{ @getDate() }"      else "#{ @getDate() }"
  hour    = if @getHours()   < 10 then "0#{ @getHours() }"     else "#{ @getHours() }"
  minutes = if @getMinutes() < 10 then "0#{ @getMinutes() }"   else "#{ @getMinutes() }"
  year    = @getFullYear()
  return "#{ year }-#{ month }-#{ day } #{ hour }:#{ minutes }"
Date::fix_dashes = (str) ->
  return str.replace /(\d{4})-(\d{2})-(\d{2})/gi, '$1/$2/$3'
