uptoDate = (name,related) -> localStorage["#{name}_version"] is version(related)

version = (related) ->
  session.versions.filter((v)-> v["n"] in related).map((v) -> v.f).reduce(((x,y) -> x + y), 0).toString()

sync = (vars, callback)->
  t = Date.now()
  async.each vars.concat(sync_base), syncOne, (err)->
    if err
      console.log("Sync Error!!")
    else
      console.log("Sync Done! in #{(Date.now() - t)} ms")
      reportLocalStorage()
      callback()

syncOne = (v,cb)->
  tt = Date.now()
  name = v['name']
  related = (sync_conf[name] and sync_conf[name]['related']) or v['related'] or []
  url     = (sync_conf[name] and sync_conf[name]['url'])     or v['url']     or "/api/#{name}"
  fresh   = (sync_conf[name] and sync_conf[name]['fresh'])   or v['fresh']   or false
  data    = (sync_conf[name] and sync_conf[name]['data'])    or v['data']    or {}
  if localStorage[name] and uptoDate(name,related)
    session[name] = $.parseJSON(localStorage[name])
    console.log "kept #{name} in #{(Date.now() - tt)} ms"
    cb()
  else
    $.get url, data, (response)->
      localStorage[name] = response unless fresh
      localStorage["#{name}_version"] = version(related) unless fresh
      session[name] = $.parseJSON(response)
      console.log "got #{name} in #{(Date.now() - tt)} ms"
      cb()

reportLocalStorage = ()->
  total = 0
  for x,data of localStorage
    do (x)->
      size = (data.length) / 1024 / 1024
      total += size
  console.log "LocalStorage Size = #{total.toFixed(1)} MB (#{(total/.05).toFixed(1)}%)"

# sync_conf = {
#   'companies'         : {related: ['companies','domains']}
#   'users'             : {related: ['users']}
#   'services'          : {related: ['services']}
#   'service_types'     : {related: ['service_types']}
#   'service_subtypes'  : {related: ['service_subtypes']}
#   'service_variants'  : {related: ['service_variants']}
#   'orders'            : {related: ['orders','services']}
#   'domains'           : {related: ['domains','services','companies'] }
#   'domain_roles'      : {related: ['domain_roles']}
#   'tickets'           : {related: ['tickets']}
#   'countries'         : {related: ['countries']}
#   'allowed_types'     : {url: 'api/users/allowed_types'}
#   'allowed_roles'     : {url: 'api/users/allowed_roles'}
# }
# sync_base = [
#   'domains',
#   'domain_roles',
#   'companies',
#   'services',
#   'service_types',
#   'service_subtypes',
#   'service_variants',
#   'service_details',
#   'countries',
#   'orders'
# ].map( (x) -> {name: x} )
