define [],() ->
  CMAP = (width,height) ->
    return ret_val = 
      width : width
      height : height
      data : []

  clamp = (source,limit) ->
    if source>=limit 
      return limit
    return source     

  pixel = (cmap,i,r,g,b) ->
    cmap.data[0+i*4] = clamp(r,0xff)
    cmap.data[1+i*4] = clamp(g,0xff)
    cmap.data[2+i*4] = clamp(b,0xff)
    cmap.data[3+i*4] = 0xff
      

  generate = (hmap) ->
    new_cmap = new CMAP(hmap.width,hmap.height)

    i = 0
    for c in hmap.data
      if c<.5
        pixel new_cmap,i,0,0,255
      else if c>.9
        c = c*0xff
        pixel new_cmap,i,c,c,c
      else
        c = c*0xff
        pixel new_cmap,i,0,c,0

      i = i+1

    return new_cmap