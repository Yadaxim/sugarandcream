$.fuzzy_matcher = (o) ->
  # o is an object with the following options
  #
  # match_text_input:     "#match-text"
  # search_in:            session.users
  # search_by_attributes: ["firstname", "lastname", "email"]
  # match_callback:       (e) -> e.matches = true
  # unmatch_callback:     (e) -> e.matches = true
  # all_callback:         fn to call when all match
  # none_callback:        fn to call when none match
  # search_mode           How to search: one of ['fuzzy', 'sub', 'exact'], defaults to 'fuzzy'
  # min_char:             min number of char to start matching (default=0) can be STRING
  # max_matches:          if all > #matches > max_matches -> call many_callback,
  # many_callback:        (must have max-matches) fn to call when all > #matches > max results
  # some_callback:        called when none < #matches < max_matches
  # perfect_callback:     called in case an element matches perfecty with search, even if others match unperfectly
  # no_char_callback:     called when char count in input < min char   
  # extra_test:           an extra test to cosider match
  # or_test:              a test to be checked besides attributes in input
  # auto_trigger:         boolean to decide if to trigger after definition
  # dropdown:             a selector id for the dropdown ul where the results are shown

  $(o.match_text_input).unbind()
  find_visible = (curr, direction) ->
    curr.removeClass 'active'
    t = (if direction is 'up' then curr.prev() else curr.next())

    return false if t.length is 0

    if t.is ':visible' then t.addClass 'active'
    else find_visible t, direction


  if o.dropdown
    # $(o.match_text_input).focusout (e) ->
    #   utils.fnRun o.all_callback

    $(o.match_text_input).focus (e) ->
      $(o.match_text_input).trigger 'input'

    $(o.match_text_input).keydown (e) ->
      active = $("#{ o.dropdown } li.active")
      $curr  = active.first()

      switch e.keyCode
        when 13 # enter
          e.preventDefault()
          $curr.find('a').click()

        when 27 #escape
          $(e.target).val null
          $(e.target).trigger 'input'

        when 38 #up
          e.preventDefault()

          if active.length is 0
            $("#{ o.dropdown } li:visible").last().addClass 'active'

          else find_visible $curr, 'up'

        when 40 #down
          e.preventDefault()

          if active.length is 0
            $("#{ o.dropdown } li:visible").first().addClass 'active'

          else find_visible $curr, 'down'

        else ;

  else
    $(o.match_text_input).keydown (e) ->
      if e.keycode is 27 #escape
        $(e.target).val null
        $(e.target).trigger 'input'


  $(o.match_text_input).bind 'input', ->

    all = true
    none = true
    count = 0
    perfects = []
    set = []

    searcheregexp = (i, mode)->
      return switch mode
        when 'fuzzy' then new RegExp i.split('').map((x)->x.regExpEscape()).join(".*?") , "i"
        when 'sub'   then new RegExp "#{ i.regExpEscape()}" , "i"
        when 'exact' then new RegExp "^#{ i.regExpEscape()}", "i"
        
        

    found_attributes = (e, inputs)->
      return false if inputs[0] is ''
      inputs.every (i)->
        re = searcheregexp(i, (o.search_mode or 'fuzzy') )
        o.search_by_attributes.some (attr)->

          if $.isFunction( attr )and (f = attr(e))
            if i.toLowerCase() is f.toLowerCase() then perfects.push(e)

            re.test(f)
          else if (a = e[attr])
            if i.toLowerCase() is a.toLowerCase() then perfects.push(e)
            re.test a
          else
            false

    o.extra_test = ((e)-> return true) unless $.isFunction o.extra_test
    o.or_test =    ((e)-> return false) unless $.isFunction o.or_test
    
    if $(o.match_text_input).val().length > (+o.min_char or 0)
      input = $(o.match_text_input).val().trim()
      inputs = [input]   # dont care about spaces if i did then #inputs = input.split(' ')

      o.search_in.forEach (e) ->
        if o.or_test(e) or (found_attributes(e, inputs) and o.extra_test(e))
          utils.fnRun o.match_callback, e
          none = false
          count += 1

          set.push e

        else
          utils.fnRun o.unmatch_callback, e
          all = false


      if perfects.length and count > +o.max_matches
        if $.isFunction o.perfect_callback
          utils.fnRun o.perfect_callback, count, input, set, perfects
        else
          utils.fnRun o.many_callback, count, input, set

      else if none
        utils.fnRun  o.none_callback, input

      else if count <= +o.max_matches and ( (o.auto_show) or (not all) or (count is 1))
        utils.fnRun o.some_callback, count, input, set

      else if all
        utils.fnRun o.all_callback , count, input, set

      else if count > +o.max_matches
        utils.fnRun  o.many_callback , count, input, set

      else ;

    else
      utils.fnRun o.all_callback, o.search_in.length ,$(o.match_text_input).val(), o.search_in


  if o.auto_trigger then $(o.match_text_input).trigger 'input'
