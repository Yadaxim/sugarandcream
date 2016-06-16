$.fn.dropdown_matcher = (o) ->

  # o is an object with the following options
  
  # required:
  # collection:       eg: session.users
  # attributes:       eg: ["firstname", "lastname", "email", ((x)-> x.p)]
  # dropdown:         id for the dropdown ul where the results are shown
 

  # many_results:    def .many-results
  # no_results:      def .no-results

  # dropdown_size:    how long should the dropdown be 
  #                   (default=10)
  
  # min_char:         min number of char to start matching
  #                   (default=1)
  
  # match_callback:   fn called on matching element
  #                   defaults: (e) -> e.matches = true

  # unmatch_callback: fn called on matching element
  #                   defaults: (e) -> e.matches = true

  # mode:             one of ['fuzzy', 'sub', 'exact'] 
  #                   defaults to 'fuzzy

  #################
  ## definitions ##
  #################
  $input = @
  match_callback = (e) ->
    if o.match_callback
      return utils.fnRun o.match_callback, e
    else
      return e.matches = true
  unmatch_callback = (e) ->
    if o.unmatch_callback
      return utils.fnRun o.unmatch_callback, e
    else
      return e.matches = false
  found_attributes = (e, inputs) ->
    inputs.every (i) ->
      re = new RegExp i.regExpEscape(), "i"
      o.attributes.some (attr)->
        e[attr].split(" ").some (j)->
          re.test j
  find_visible = (curr, direction) ->
    curr.removeClass 'active'
    t = (if direction is 'up' then curr.prev() else curr.next())
    return false if t.length is 0
    if t.is ':visible' then t.addClass 'active'
    else find_visible t, direction
    
  reset_dropdown = ->
    $("#{ o.dropdown } li").removeClass 'active'
    $("#{ o.dropdown } li:visible").first().addClass 'active'
    $("#{ o.dropdown } .too-many").hide()
    $("#{ o.dropdown } .no-results").hide()
  #################
  ## if dropdown ##
  #################
  if o.dropdown
    $input.blur (e) ->
      setTimeout (-> $(o.dropdown).hide()), 500
    $input.focus (e) ->
      $input.trigger 'input'
    $input.keydown (e) ->
      active = $("#{ o.dropdown } li.active")
      $curr  = active.first()
      switch e.keyCode
        when 13 # enter
          e.preventDefault()
          $curr.find('a').click()
        when 38 # up
          e.preventDefault()
          if active.length is 0
            $("#{ o.dropdown } li:visible").last().addClass 'active'
          else find_visible $curr, 'up'
        when 40 # down
          e.preventDefault()
          if active.length is 0
            $("#{ o.dropdown } li:visible").first().addClass 'active'
          else find_visible $curr, 'down'
        else ;
  ############################
  ##  bind the thing now... ##
  ############################
  $input.keydown (e) ->
    if e.keycode is 27 # escape
      $(e.target).val null
      $(e.target).trigger 'input'
  $input.bind 'input', ->

    value = $input.val()
    if value.length >= (+o.min_char or 1)
      words = value.split(" ")
      count = 0
      o.collection.forEach (e) ->
        if found_attributes e, words
          match_callback e
          count += 1
        else
          unmatch_callback e
      if o.dropdown
        reset_dropdown()
        switch
          when value.length == 0
            if o.no_results    then $("#{ o.no_results  }").hide() else  $(".no-results").hide()
            if o.many_results  then $("#{ o.many_results}").hide() else  $(".many-results").hide()
            $("#{ o.dropdown}").hide()
           
          when not count
            if o.no_results    then $("#{ o.no_results  }").show() else  $(".no-results").show()
            if o.many_results  then $("#{ o.many_results}").hide() else  $(".many-results").hide()

            $("#{ o.dropdown}").hide()
            
          when count > (o.dropdown_size or 10)
            if o.no_results    then $("#{ o.no_results  }").hide() else  $(".no-results").hide()
            if o.many_results  then $("#{ o.many_results}").show() else  $(".many-results").show()

            $("#{ o.dropdown}").hide()
           
          else
            if o.no_results    then $("#{ o.no_results  }").hide() else  $(".no-results").hide()
            if o.many_results  then $("#{ o.many_results}").hide() else  $(".many-results").hide()

            $("#{ o.dropdown}").show()
            
    else #reset 0 chars
      unmatch_callback(e) for e in o.collection

      reset_dropdown() if o.dropdown
