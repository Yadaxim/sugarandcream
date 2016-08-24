navigator.sayswho = do ->
  ua = navigator.userAgent
  tem = undefined
  M = ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) or []
  if /trident/i.test(M[1])
    tem = /\brv[ :]+(\d+)/g.exec(ua) or []
    return 'IE ' + (tem[1] or '')
  if M[1] == 'Chrome'
    tem = ua.match(/\b(OPR|Edge)\/(\d+)/)
    if tem != null
      return tem.slice(1).join(' ').replace('OPR', 'Opera')
  M = if M[2] then [
    M[1]
    M[2]
  ] else [
    navigator.appName
    navigator.appVersion
    '-?'
  ]
  if (tem = ua.match(/version\/(\d+)/i)) != null
    M.splice 1, 1, tem[1]
  M.join ' '
