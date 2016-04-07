# TODO: (BUG) This code is duplicated from location.coffee... fix the
# loading issue or rewrite when making changes
#
if not window.location.getQueryParam?
#  console.log "getQueryParams has not been loaded! Redefining..."
  window.location.getQueryParam = (param) ->
    p       = param.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex   = new RegExp "[\\?&]" + p + "=([^&#]*)"
    results = regex.exec location.search
    if results is null then "" else decodeURIComponent results[1].replace(/\+/g, " ")
window.dictionary = {}
window.translator = (dict) ->
  lang = location.getQueryParam('lang') or localStorage['lang'] or 'es'
  localStorage['lang'] = lang
  for k,v of dict
    window.dictionary[k] = v[lang]
window.base_dictionary =
  cancel:
    es: "Cancelar"
    en: "Cancel"
  alert:
    es: "Alerta"
    en: "Alert"
  OK:
    es: "OK"
    en: "OK"
  error:
    es: "Error"
    en: "Error"
  weekdays:
    es: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado']
    en: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  months:
    es: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
    en: ['January', 'February', 'Mach', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  working:
    es: "Trabajando..."
    en: "Working..."
  file:
    es: "Archivo"
    en: "File"
  line:
    es: "Línea"
    en: "Line"
  js_error:
    es: "Error de JS"
    en: "JS error"
  js_error_message:
    es: "Hubo un error en el navegador, por favor reporta los siguientes datos a un administrador."
    en: "This is probably a bug on the browser, report the following details to an administrator."
  almost:
    es: "Casi"
    en: "Almost"
  done:
    es: "¡Listo!"
    en: "¡Done!"
  clear:
    es: "Limpiar"
    en: "Clear"
  filetype_error_title:
    es: "Tipo de archivo"
    en: "File type error"
  filetype_error_message:
    es: "Sólo se pueden subis los siguientes tipos de archivos:"
    en: "File is not in the accepted file types:"
  filesize_error_title:
    es: "Tamaño de archivo"
    en: "File size error"
  filesize_error_message:
    es: "¡El archivo es demasiado grande! El límite es: "
    en: "File is too large! The limit is: "
  and:
    es: "y"
    en: "and"
translator window.base_dictionary
