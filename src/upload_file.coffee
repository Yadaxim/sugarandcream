$.fn.uploadFile = (o) ->
  $el = @
  # ajax request
  #
  # p: route for the request
  # m: request method (eg. "PUT", "POST")
  # x: an object as extra payload to the request
  p = o.url
  m = o.type or "POST"
  x = o.payload or {}
  # file restrictions
  #
  # l: maximum size for the file upload in bytes (4,000,000 == 4MB)
  # t: an array with whitelisted extensions ([] or null means no restrictions)
  l = o.max_size or 4000000
  t = o.extensions or []
  # callbacks
  #
  # q: on exentension list error (takes the extension and extension list as arguments)
  # g: what to do before the ajax request
  # u: what to do with the progress percentage number?
  # c: on success... (takes the response as an argument)
  # b: on error (takes xhr, test, error as an arguments [as jquery])
  # z: filesize error (takes the filesize as an argument)
  q = o.extension_error or (ext,list) ->
    bs.alert
      title: dictionary['filetype_error_title']
      text:  "#{ dictionary['filetype_error_message'] } #{ list.humanPrint ', ', dictionary['and'] }"
  g = (xhr) ->
    o.before? and o.before xhr
    $('#upload-progress').text '0%'
    $('#upload-progress-modal').modal 'show'
  u = o.progress or (progress) ->
    $('#upload-progress').text () ->
      if progress is '100%' then "#{ dictionary['almost'] }..."
      else progress
  c = (response) ->
    o.success? and o.success response
    $('#upload-progress').text dictionary['done']
    $('#upload-progress-modal').modal 'hide'
  b = (xhr, text, error) ->
    if xhr.status is 413
      $('#upload-progress').text dictionary['file_too_large']
    o.error xhr, text, error
  z = o.filesize_error or (size) ->
    bs.alert
      title: dictionary['filesize_error_title']
      text:  "#{ dictionary['filesize_error_message'] } #{ l }"
  # Everything's ready now. GO!
  fd = new FormData()
  f = @[0].files[0]
  ext = (f.name || f.fileName).split('.').pop().toLowerCase()
  if t.length and ext not in t
    q ext, t
    return false
  return false unless f  # hack for Chrome
  settings =
    error:    $.noop
    success:  $.noop
    start:    $.noop
    complete: $.noop
  fd.append @attr('name'), f
  fd.append k, v for k, v of x
  $.ajax
    type: m
    url:  p
    data: fd
    cache:       false
    contentType: false
    processData: false
    xhr: ->
      xhr = $.ajaxSettings.xhr()
      xhr.upload.onprogress = (rpe) ->
        u (rpe.loaded / rpe.total * 100 >> 0) + '%'
      xhr.onloadstart = ->
        settings.start.apply self
      return xhr
    beforeSend: (xhr) ->
      if f.size > l
        xhr.abort()
        z f.size
        return false
      xhr.setRequestHeader "X-XHR-Upload", "1"
      xhr.setRequestHeader "X-File-Name", f.name || f.fileName
      xhr.setRequestHeader "X-File-Size", f.fileSize || f.size
      g xhr
    error: (xhr, text, error) ->
      b xhr, text, error
    success: (response) ->
      c response
