$('#navbar-tools').find('a').each (i,e) ->
  ee = $(e)
  if ee.attr('href') is window.location.pathname
    # ee.closest('li').addClass( 'active')
    # ee.attr('href', null)
    ee.remove()
window.bs =
  alert: (o) ->
    $('#alert-modal').unbind()
    $('#alert-modal [bind="title"]').text o.title or dictionary['alert']
    $('#alert-modal [bind="text"]').text o.text
    $('#alert-modal [bind="text"]').html o.html if o.html
    $('#alert-modal [bind="confirm"]').text o.confirm or dictionary['OK']
    $('#alert-modal [bind="confirm"]').addClass "btn-" + (o.confirm_btn_class or "default")
    $('#alert-modal').modal 'show'
    if $.isFunction o.callback
      $('#alert-modal').on 'hide.bs.modal', -> o.callback()
  confirm: (o) ->
    ['#confirm-yes', '#confirm-no'].forEach (s) -> $(s).unbind()
    $('#confirm-modal [bind="title"]').text o.title or dictionary['confirm']
    $('#confirm-modal [bind="text"]').text o.text
    $('#confirm-modal [bind="text"]').html o.html if o.html
    $('#confirm-modal [bind="confirm"]').text o.confirm or dictionary['OK']
    $('#confirm-modal [bind="cancel"]').text o.cancel or dictionary['cancel']
    $('#confirm-modal [bind="confirm"]').addClass "btn-" + (o.confirm_btn_class or "default")
    $('#confirm-modal [bind="cancel"]').addClass "btn-" + (o.cancel_btn_class or "default")
    $('#confirm-modal').modal 'show'
    $('#confirm-yes').on 'click', ->
      $('#confirm-modal').modal 'hide'
      o.callback() if $.isFunction o.callback
    $('#confirm-no').on 'click', ->
      $('#confirm-modal').modal 'hide'
  modal: (o) ->
    id = o.id
    $("##{ id }-modal").remove()
    if not id? then throw "bs.modal: Need an id"
    # m: include form tag with form_id around
    #    modal-header - modal-body - modal-footer
    m = o.form
    # h: include header?
    # t: title inside the header
    # x: close button?
    # b: the (id of the) text/template for the body
    # f: the (id of the) text/template for the footer
    # e: modal fades in/out
    # p: backdrop (outside click closes modal)
    # k: keyboard (esc closes modal)
    x = if o.close isnt false then true
    h = if o.header isnt false then true
    t = o.title
    b = o.body   or $("##{ id }-modal-body").html()
    f = o.footer or $("##{ id }-modal-footer").html()
    e = if o.fade is true then "fade" else ""
    p = if o.backdrop in ["static", true, false] then o.backdrop else true
    k = if o.keyboard isnt false then true
    if h? and not t? then throw "bs.modal: If a hedear is to be set, a title is required."
    # show the modal immediately after created
    s = o.show or false
    # bo: run before opening (but after populating the modal?)
    # ao: run after opening
    # bc: run before closing
    # ac: run after closing
    # d: wether to destroy the modal after closed (before ac)
    d = if o.destroy isnt false then true
    # GO!
    html = ""
    html += "<div id='#{ id }-modal' class='modal #{ e }'"
    html += "data-keyboard='#{ k }'"
    html += "data-backdrop='#{ p }'"
    html += ">"
    html +=   "<div class='modal-dialog'>"
    html +=     "<div class='modal-content'>"
    if m? then html += "<form id='#{ id }-modal-form'>"
    if h?
      html += "<div class='modal-header'>"
      if x? then html += "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>"
      if t? then html += "<h4 class='modal-title'>#{ t }</h4>"
      html += "</div>"
    if b? then html += "<div class='modal-body'>#{ b }</div>"
    if f? then html += "<div class='modal-footer'>#{ f }</div>"
    if m? then html += "</form>"
    html +=     "</div>"
    html +=   "</div>"
    html += "</div>"
    $('#content').append html
    if s then $("##{ id }-modal").modal 'show'
  tooltips: ->
    $('[bind="tooltip"]').tooltip
      toggle:    'tooltip'
      placement: 'auto'
      delay:
        show: 150
        hide: 0

  popovers: ->
    $('[data-toggle="popover"]').popover
        toggle:    'popover'
        html:      'true'
        trigger:   'hover'
        placement: 'auto'
        delay:
          show: 150
          hide: 0


  popovers_on: (selector) ->
    # there are bootstrap's errors on hidden elements
    # call this function after show hidden elements with nested popovers 
    bs.popovers_destroy selector
    $("#{ selector } [data-toggle='popover']").popover
        toggle:    'popover'
        html:      'true'
        trigger:   'hover'
        placement: 'auto'
        delay:
          show: 150
          hide: 0

  popovers_destroy: (selector) ->
    # call this function on hide element with nested popovers
    $("#{ selector } [data-toggle='popover']").popover "destroy"
