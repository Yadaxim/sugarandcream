Number::toCurrency = (exchange_rate) -> "$" +(@ * (if exchange_rate then exchange_rate else 1)).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,')

Number::ms2coloquial = ->

  DAY = 1000 * 60 * 60  * 24

  r = @/DAY

  if r > 356
      return (y = (r/356).toFixed(1)) + (if y is 1 then " year" else " years")
    if r > 30
      return (m = Math.round(r/30) )+ (if m is 1 then " month" else " months")
    if r > 7
      return (w = Math.round(r/7)) + (if w is 1 then " week" else " weeks")
    else
      return Math.round(r) + (if r is 1 then " day" else " days")

Number::digits = ->
   if @ is 0 then 1 else Math.floor(Math.log10(@) + 1)
