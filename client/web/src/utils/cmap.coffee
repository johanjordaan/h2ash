define [],() ->
  CMAP = (width,height) ->
    size = width*height
    data = new Uint8Array(4*size)
    return ret_val = 
      size : size
      width : width
      height : height
      data : data

  split_hex_color_to_rbg = (hex_color) ->
    return rgb = 
      r : (hex_color&0xFF0000)>>16
      g : (hex_color&0x00FF00)>>8
      b : (hex_color&0x0000FF)

  combine_rgb_into_hex_color = (rgb) ->
    return (rgb.r<<16)+(rgb.g<<8)+(rgb.b);    


  pixel = (cmap,i,hex_color) ->
    rgb = split_hex_color_to_rbg(hex_color)
    cmap.data[0+i*4] = rgb.r
    cmap.data[1+i*4] = rgb.g
    cmap.data[2+i*4] = rgb.b
    cmap.data[3+i*4] = 0xff


  types = [
    [
      { from : 0.0 , to : 0.5 , from_color : 0x3299CC, to_color : 0x3299CC, specular : 0x555555, bump_from : 0.5 , bump_to : 0.5 },
      { from : 0.5 , to : 0.95, from_color : 0x8B4513, to_color : 0x5C4033, specular : 0x000000, bump_from : 0.5 , bump_to : 0.95 },
      { from : 0.95, to : 1.00, from_color : 0xFFFFFF, to_color : 0xFFFFFF, specular : 0xaaaaaa, bump_from : 0.95, bump_to : 1.00 },
    ],
    [
      { from : 0.0 , to : 0.4 , from_color : 0x0000AA, to_color : 0x0000AA, specular : 0x555555, bump_from : 0.4 , bump_to : 0.4 },
      { from : 0.4 , to : 0.9 , from_color : 0x009900, to_color : 0x003300, specular : 0x000000, bump_from : 0.4 , bump_to : 0.90 },
      { from : 0.90, to : 1.00, from_color : 0xFFFFFF, to_color : 0xFFFFFF, specular : 0xaaaaaa, bump_from : 0.90, bump_to : 1.00 },
    ],
    [
      { from : 0.0 , to : 1.0 , from_color : 0xAAAAAA, to_color : 0xCCCCCC, specular : 0x000000, bump_from : 0.0 , bump_to : 0.5 },
    ],
    [
      { from : 0.0 , to : 0.5 , from_color : 0xFFFFFF, to_color : 0xFFFFFF, specular : 0x555555, bump_from : 0.4 , bump_to : 0.5 },
      { from : 0.5 , to : 0.95, from_color : 0x8B4513, to_color : 0x5C4033, specular : 0x000000, bump_from : 0.5 , bump_to : 0.95 },
      { from : 0.95, to : 1.00, from_color : 0xFFFFFF, to_color : 0xFFFFFF, specular : 0xaaaaaa, bump_from : 0.95, bump_to : 1.00 },
    ],
    [
      { from : 0.0 , to : 0.5 , from_color : 0xFF3333, to_color : 0xFF6666, specular : 0x555555, bump_from : 0.4 , bump_to : 0.5 },
      { from : 0.5 , to : 0.95, from_color : 0xFF4513, to_color : 0xFF4033, specular : 0x000000, bump_from : 0.5 , bump_to : 0.95 },
      { from : 0.95, to : 1.00, from_color : 0xFFFFFF, to_color : 0xFFFFFF, specular : 0xaaaaaa, bump_from : 0.95, bump_to : 1.00 },
    ],
  ]

  interpolate_color = (from,to,val) ->
    from_rgb = split_hex_color_to_rbg(from)
    to_rgb = split_hex_color_to_rbg(from)

    rgb = 
      r : from_rgb.r +  val*(to_rgb.r - from_rgb.r)
      g : from_rgb.g +  val*(to_rgb.g - from_rgb.g)
      b : from_rgb.b +  val*(to_rgb.b - from_rgb.b)

    return combine_rgb_into_hex_color(rgb)


  scale_color = (base,val) ->
    rgb = split_hex_color_to_rbg(base)

    rgb.r = val * rgb.r
    rgb.g = val * rgb.g
    rgb.b = val * rgb.b

    return combine_rgb_into_hex_color(rgb)

  interpolate = (from,to,val) ->
    ret_val = from + val * (to-from) 
    return ret_val 

  generate = (hmap,index) ->
    new_cmap = new CMAP(hmap.width,hmap.height)
    new_smap = new CMAP(hmap.width,hmap.height)
    new_bmap = new CMAP(hmap.width,hmap.height)

    # from,to -> Define from which height to which to apply the rule (0,1)
    # from_color, to_color -> Define which colors to apply using linear interpolation
    # specular value for the range
    # 
    type = types[index]

    i = 0
    for c in hmap.data
      
      for band in type
        if c>=band.from && c < band.to
          pixel new_cmap,i,interpolate_color(band.from_color,band.to_color,c)
          pixel new_smap,i,band.specular
          pixel new_bmap,i,scale_color(0xFFFFFF,interpolate(band.bump_from,band.bump_to,c))

      i = i+1

    return cmaps =
     cmap : new_cmap
     smap : new_smap
     bmap : new_bmap