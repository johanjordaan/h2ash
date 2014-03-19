# nice noise http://lodev.org/cgtutor/randomnoise.html
define ['underscore','../utils/rnd'],(_,rnd) ->
  HMAP = (width,height,data) ->
    return ret_val =
      size : width*height 
      width : width
      height : height
      data : data    

  generate_noise = (width,height) ->     
    size = width*height
    noise = []
    i = 0
    while i<size
      noise[i] = rnd.random()
      i = i + 1     
    return noise

  zoom = (noise,size) ->
    zoomed_noise = []
    i = 0
    while i<noise.size
      y = Math.floor(i/noise.width)
      x = i%noise.width
      zoomed_noise[i] = noise.data[Math.floor(x/size)+Math.floor(y/size)*noise.width]
      i = i + 1
    return zoomed_noise





  bilinear_filter = (noise,x,y,zoom) ->
    x0 = x/zoom
    y0 = y/zoom
    x0_int = Math.floor(x0)
    y0_int = Math.floor(y0)

    fractX = x0 - x0_int
    fractY = y0 - y0_int

    x1 = (x0_int)
    y1 = (y0_int)
   
    x2 = (x0_int + noise.width - 1) % (noise.width/zoom)
    y2 = (y0_int + noise.height - 1) % (noise.height/zoom)

    value = 0
    value += fractX       * fractY       * noise.data[x1+y1*noise.width]
    value += fractX       * (1 - fractY) * noise.data[x1+y2*noise.width]
    value += (1 - fractX) * fractY       * noise.data[x2+y1*noise.width]
    value += (1 - fractX) * (1 - fractY) * noise.data[x2+y2*noise.width]

    return value
      
  smooth_noise = (noise,zoom) ->
    zoomed_noise = []
    i = 0
    while i<noise.size
      y = Math.floor(i/noise.width)
      x = i%noise.width
      zoomed_noise[i] = bilinear_filter(noise,x,y,zoom)
      i = i + 1
    return zoomed_noise

  turbulence = (noise,x,y,size) ->
    value = 0
    initialSize = size
    
    while(size >= 1)
        value += bilinear_filter(noise, x, y, size) * size;
        size /= 2;
    
    return value

  turbulence_noise = (noise,size) ->
    zoomed_noise = []
    i = 0
    while i<noise.size
      y = Math.floor(i/noise.width)
      x = i%noise.width
      zoomed_noise[i] = turbulence(noise,x,y,size)
      i = i + 1
    return zoomed_noise

  turbulence2_noise = (noise,size) ->
    x_period = 0
    y_period = 3
    turbo_power = 5
    turbo_size = size  

    zoomed_noise = []
    i = 0
    while i<noise.size
      y = Math.floor(i/noise.width)
      x = i%noise.width

      x_v = x * x_period / noise.width 
      y_v = y * y_period / noise.height
      turbo = turbo_power * turbulence(noise,x, y, turbo_size) / noise.width
      xy_v = x_v + y_v + turbo
      v = noise.width*Math.abs(Math.sin( (xy_v)* 3.14159) )
      
      zoomed_noise[i] = v
      i = i + 1

    return zoomed_noise

  normalise = (noise) ->
    min = max = noise.data[0]
    for c in noise.data
      if c<min
        min = c
      if c>max
        max = c

    ret_val = new HMAP(noise.width,noise.height,[])    
    for i in _.range(noise.width*noise.height)
      ret_val.data[i] = (noise.data[i]-Math.abs(min)) / (max-min)
    return ret_val

  generate = (width,height) ->
    noise = new HMAP(width,height,generate_noise(width,height))
    zoomed_noise = new HMAP(width,height,zoom(noise,16))
    smoothed_noise = new HMAP(width,height,smooth_noise(noise,8))
    tnoise = new HMAP(width,height,turbulence2_noise(noise,32))
    ntnoise = normalise(tnoise)


    #return zoomed_noise
    return ntnoise

