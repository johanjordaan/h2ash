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

      
  

  generate = (width,height) ->
    noise = new HMAP(width,height,generate_noise(width,height))
    zoomed_noise = new HMAP(width,height,zoom(noise,16))

    return zoomed_noise

