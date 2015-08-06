# -------------------------------
# Svg Sprites Render
#
# Description: Load svg file and place into html <svg>.
# http://www.soopro.com
#
# Author:   redy
# Date:     14 July 2015
# Version:  0.0.8
# -------------------------------

if not window
  throw new Error("For web browser only!!")

window.svgSprites = ->
  sprites = {}
  load_stack = []
  self = @
  
  request = (opts) ->
    if not opts
      throw new Error("Request Options is required");
    req_url = opts.url
    req_async = opts.async or true
    req_user = opts.user or ''
    req_password = opts.password or ''
    req_timeout = opts.timeout or 0
    
    if not req_url
      throw new Error("Request URL is required");

    success_callback = opts.success
    error_callback = opts.error
    complete_callback = opts.complete

    xmlhttp = new XMLHttpRequest()
    
    # timeout
    xmlhttp.timeout = req_timeout
    xmlhttp.ontimeout = ->
      console.error("The request for "+req_url+" timed out.")
    
    # statechange
    xmlhttp.onreadystatechange = ->
      if xmlhttp.readyState == XMLHttpRequest.DONE
        if xmlhttp.status == 200
          if typeof(success_callback) is 'function'
            success_callback(xmlhttp.response, xmlhttp.status)
        else
          if typeof(error_callback) is 'function'
            error_callback(xmlhttp.response, xmlhttp.status)
        if typeof(complete_callback) is 'function'
          complete_callback(xmlhttp.response, xmlhttp.status)
      return
    
    # fire
    xmlhttp.open("GET", req_url, req_async, req_user, req_password)
    xmlhttp.setRequestHeader("Accept", "text/xml")
    xmlhttp.send()

  
  remove_load = (str)->
    idx = load_stack.indexOf(str)
    if idx > -1
      load_stack.splice(idx, 1)
    return

  append_svg = (data, name) ->
    fragment = document.createElement("div")
    fragment.innerHTML = data
    svgs = fragment.querySelectorAll("[id]")
    sprites[name] = {}
    for svg in svgs
      try
        view_box = svg.getAttribute('viewBox')
        if not view_box
          continue
        if svg.id not in sprites[name]
          sprites[name][svg.id] = 
            children: (child for child in svg.childNodes when child.nodeType is 1)
            view: view_box
        else
          throw new Error("SVG ID is duplicated!!")
      catch err
        console.error err
    return
  
  isHTMLElement = (o) ->
    is_obj = o and typeof o == 'object' and o != null
    is_obj_type = o.nodeType is 1 and typeof o.nodeName is 'string'
    result =  is_obj and is_obj_type
    return result
  
  render_svg = (element) ->
    if not element or not isHTMLElement(element)
      element = document
    
    if element.nodeName.toUpperCase() is 'SVG' and element.getAttribute("svg-sprite")
      svg_elements = [element]
    else
      svg_elements = element.querySelectorAll("svg[svg-sprite]")
    
    for svg in svg_elements
      target = svg.getAttribute("svg-sprite")
      if not target
        continue

      target_split = target.split(":")
      if target_split.length < 2
        continue
      
      gp = target_split[0]
      id = target_split[1]

      group = sprites[gp]

      while svg.firstChild
        svg.removeChild(svg.firstChild)
      
      if id and group and group.hasOwnProperty(id)
        for child in group[id].children
          svg.appendChild(child.cloneNode(true))
        svg.setAttribute('viewBox', group[id].view)
      else
        console.error "SVG Sprite '"+target+"' not found:"
        console.log gp, id
        console.log sprites, group
    return
  
  @load = (svg_url, svg_name) ->
    if not svg_name
      svg_name = svg_url.replace(/^.*[\\\/]/, '')
    
    load_stack.push(svg_url)
    
    console.log "SVG Sprites load "+svg_url+" ["+svg_name+"]"
    
    request
      type: 'GET'
      url: svg_url
      success: (data) ->        
        append_svg(data, svg_name)
        remove_load(svg_url)
      error: (xhr, type) ->
        console.error('Ajax error! '+type, xhr)
        remove_load(svg_url)
        return
    return
  
  @render = (element, timeout)->
    if not timeout
      timeout = 30000
    timeout = new Date().getTime()+timeout
    
    timer = setInterval ->
      try
        if load_stack.length <= 0
          clearInterval(timer)
          render_svg(element)
        if new Date().getTime() > timeout
          clearInterval(timer)
          throw new Error("SVG Sprites render timeout!!")
      catch err
        console.error err
    , 100
    
    return
    
  return @