prettyFormat = (s) ->
  # We use this for DB validation errors, it's quite specific
  try
    r = new String
    pj = JSON.parse s
    r += "#{ k }: #{ pj[k] } <br />" for k of pj
    return r
  catch e
    return s
noKeyFormat = (s) ->
  try
    return (for own k,v of JSON.parse s
      "#{ v }<br />").join ""
  catch
    return s
window.flash =
  css: ->
    console.log "
  This is a sample CSS for this to look nicely: \n
\n
[bind='flash'] {\n
  opacity: 0.9;\n
  border-radius: 0 !important;\n
}\n
\n
#js-error { margin: 100px !important; }\n
\n
#api-message-container {\n
  position: fixed;\n
  width: 100%;\n
  margin: auto;\n
  top: 15px;\n
  text-align: center;\n
  z-index: 9999;\n
}\n
\n
#api-message-container > span.alert { padding: 16px; }\n
#api-message-container > div.error { margin-top: -16px; }\n
    "
  error: (t) ->
    # errors will use divs so they are more exagerated (the take the entire width because of this)
    $('#api-message-container').append "<div class='error alert alert-danger' bind='flash'><span bind='error-message'>#{ t }</span></div>"
  success: (t) ->
    $('[bind="flash"]').remove()
    $('#api-message-container').append "<span class='success alert alert-success' bind='flash'><span bind='message'>#{ t }</span></span>"
    $('[bind="flash"]')
      .delay 5000
      .fadeOut 'fast'
  info: (t) ->
    $('#api-message-container').append "<span class='info alert alert-info' bind='flash'>#{ t }</span>"

$(document).ajaxStart ->
  $('[bind="flash"]').remove()

workingTimeout = undefined
$(document).ajaxSend ->
  workingTimeout = setTimeout( (()-> flash.info dictionary['working']), 20)

$(document).ajaxSuccess (event, xhr, options) ->
  m = xhr.getResponseHeader 'API-Message'
  if m not in [null,undefined]
    flash.success decodeURIComponent(escape m)

$(document).ajaxError (event, xhr, ajaxOptions, thrownError) ->
  if xhr.status is 422
    flash.error prettyFormat(xhr.responseText)
  else if xhr.status is 401
    window.location = '/login'
  else
    flash.error prettyFormat("#{ xhr.status }: #{ prettyFormat(xhr.responseText) }")

$(document).ajaxComplete (event, xhr) ->
  clearTimeout(workingTimeout)
  $('[bind="flash"].info').remove()

$(document).on 'click', '#api-message-container', ->
  $('[bind="flash"]').remove()

window.onerror = (errorrs, file, line) ->
  $('[bind="flash"].info').remove()
  $('body').prepend "<div id='js-error' class='error alert alert-danger'>
    <p>
      <b>#{ dictionary['js_error'] }</b> #{ dictionary['js_error_message'] }
    </p>
    <p>
      #{ dictionary['error'] }: #{ errorrs }<br />
      #{ dictionary['file'] }:  #{ file }<br />
      #{ dictionary['line'] }:  #{ line }
    </p>
    </div>"
  return false
