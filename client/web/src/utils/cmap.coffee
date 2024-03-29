# nice noise http://lodev.org/cgtutor/randomnoise.html

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
      r : (hex_color&0xFF0000)>>>16
      g : (hex_color&0x00FF00)>>>8
      b : (hex_color&0x0000FF)

  combine_rgb_into_hex_color = (rgb) ->
    return ((rgb.r&0xFF)<<16)+((rgb.g&0xFF)<<8)+((rgb.b&0xFF))


  pixel = (cmap,i,hex_color,alpha) ->
    rgb = split_hex_color_to_rbg(hex_color)
    cmap.data[0+i*4] = rgb.r
    cmap.data[1+i*4] = rgb.g
    cmap.data[2+i*4] = rgb.b
    cmap.data[3+i*4] = alpha


  types = [
    [
      { from : 0.0 , to : 0.5 , from_color : 0x000000, to_color : 0x3299CC, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0xFFFFFF, bump_from : 0.5 , bump_to : 0.5 },
      { from : 0.5 , to : 0.95, from_color : 0x8B4513, to_color : 0x5C4013, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0x000000, bump_from : 0.5 , bump_to : 0.95 },
      { from : 0.95, to : 1.00, from_color : 0xFFFFFF, to_color : 0xFFFFFF, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0xaaaaaa, bump_from : 0.95, bump_to : 1.00 },
    ],
    [
      { from : 0.0 , to : 0.8 , from_color : 0x0000AA, to_color : 0x0000AA, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0x555555, bump_from : 0.4 , bump_to : 0.4 },
      { from : 0.8 , to : 0.95 , from_color : 0x009900, to_color : 0x003300, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0x000000, bump_from : 0.4 , bump_to : 0.90 },
      { from : 0.95, to : 1.00, from_color : 0xFFFFFF, to_color : 0xFFFFFF, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0xaaaaaa, bump_from : 0.90, bump_to : 1.00 },
    ],
    [
      { from : 0.0 , to : 1.0 , from_color : 0x333333, to_color : 0xAAAAAA, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0x000000, bump_from : 0.0 , bump_to : 1.0 },
    ],
    [
      { from : 0.0 , to : 0.5 , from_color : 0xFFFFFF, to_color : 0xFFFFFF, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0x555555, bump_from : 0.4 , bump_to : 0.5 },
      { from : 0.5 , to : 0.95, from_color : 0x8B4513, to_color : 0x5C4033, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0x000000, bump_from : 0.5 , bump_to : 0.95 },
      { from : 0.95, to : 1.00, from_color : 0xFFFFFF, to_color : 0xFFFFFF, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0xaaaaaa, bump_from : 0.95, bump_to : 1.00 },
    ],
    [
      { from : 0.0 , to : 0.5 , from_color : 0xFF3333, to_color : 0xFF6666, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0x555555, bump_from : 0.4 , bump_to : 0.5 },
      { from : 0.5 , to : 0.95, from_color : 0xFF4513, to_color : 0xFF4033, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0x000000, bump_from : 0.5 , bump_to : 0.95 },
      { from : 0.95, to : 1.00, from_color : 0xFFFFFF, to_color : 0xFFFFFF, from_alpha : 0xFF, to_alpha: 0xFF, specular : 0xaaaaaa, bump_from : 0.95, bump_to : 1.00 },
    ],
    [
      { from : 0.5 , to : 1.0 , from_color : 0xFFFFFF, to_color : 0xFFFFFF, from_alpha : 0x00, to_alpha: 0xFF, specular : 0x000000, bump_from : 0.0 , bump_to : 0.0},
    ],
    [
      { from : 0.3 , to : 1.0 , from_color : 0x8B4513, to_color : 0x8B4513, from_alpha : 0x00, to_alpha: 0xFF, specular : 0x000000, bump_from : 0.0 , bump_to : 0.0},
    ],
    [
      { from : 0.3 , to : 1.0 , from_color : 0x0000FF, to_color : 0x0000FF, from_alpha : 0x00, to_alpha: 0xFF, specular : 0x000000, bump_from : 0.0 , bump_to : 0.0},
    ],
  ]

  interpolate_color = (from,to,val) ->
    from_rgb = split_hex_color_to_rbg(from)
    to_rgb = split_hex_color_to_rbg(to)
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
          c_n = (c-band.from)/(band.to-band.from)
          pixel new_cmap,i,interpolate_color(band.from_color,band.to_color,c_n),interpolate(band.from_alpha,band.to_alpha,c_n)
          pixel new_smap,i,band.specular,0xFF
          pixel new_bmap,i,scale_color(0xFFFFFF,interpolate(band.bump_from,band.bump_to,c_n)),0xFF

      i = i+1

    return cmaps =
     cmap : new_cmap
     smap : new_smap
     bmap : new_bmap