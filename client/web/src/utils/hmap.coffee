#http://www.bluh.org/code-the-diamond-square-algorithm/
define [],() ->
  HMAP = (width,height) ->
    return ret_val = 
      width : width
      height : height
      data : []

  sample = (hmap,x,y) ->
    return hmap.data[(x & (hmap.width - 1)) + (y & (hmap.height - 1)) * hmap.width]
   
  set_sample = (hmap,x,y,value) ->
    hmap.data[(x & (hmap.width - 1)) + (y & (hmap.height - 1)) * hmap.width] = value

  frand = () ->
    return (0.5 - Math.random())*2

  init = (hmap,feature_size) ->
    for i in _.range(hmap.width*hmap.height)
      hmap.data[i] = -1

    for y in _.range(0,hmap.height,feature_size)
      for x in _.range(0,hmap.width,feature_size)
        set_sample(hmap,x, y, frand())


  sample_square = (hmap,x,y,size,value) ->
    hs = size / 2

    # a     b 
    #
    #    x
    #
    # c     d
   
    a = sample(hmap,x - hs, y - hs)
    b = sample(hmap,x + hs, y - hs)
    c = sample(hmap,x - hs, y + hs)
    d = sample(hmap,x + hs, y + hs)
   
    set_sample(hmap,x, y, ((a + b + c + d) / 4.0) + value)

  sample_diamond = (hmap,x,y,size,value) ->
    hs = size / 2
   
    #    c
    #
    # a  x  b
    #
    #    d

    a = sample(hmap,x - hs, y)
    b = sample(hmap,x + hs, y)
    c = sample(hmap,x, y - hs)
    d = sample(hmap,x, y + hs)

    set_sample(hmap,x, y, ((a + b + c + d) / 4.0) + value)

  diamond_square = (hmap,stepsize,scale) ->
    halfstep = stepsize / 2

    for y in _.range(halfstep,hmap.height+halfstep,stepsize)
      for x in _.range(halfstep,hmap.width+halfstep,stepsize)
          sample_square(hmap,x,y,stepsize,frand() * scale)

    for y in _.range(0,hmap.height,stepsize)
      for x in _.range(0,hmap.width,stepsize)
        sample_diamond(hmap,x + halfstep, y, stepsize, frand() * scale)
        sample_diamond(hmap,x, y + halfstep, stepsize, frand() * scale)

  generate = (width,height,feature_size) ->
    new_hmap = new HMAP(width,height)
    init new_hmap,feature_size    

    sample_size = feature_size
 
    scale = 1.0
 
    while (sample_size > 1)
      diamond_square(new_hmap,sample_size, scale)
 
      sample_size = sample_size/2
      scale = scale/2.0

    return new_hmap  
