define ['underscore','../utils/cmap','../utils/noise'], (_,cmap,noise) ->

  generate_planet = (index,x_period,y_period,power,size) ->
    map_width = 512
    map_height = 256
    bump_scale = 3
    hdata = noise(map_width,map_height,x_period,y_period,power,size)
    
    cdata = cmap(hdata,index)

    texture = new THREE.DataTexture(cdata.cmap.data,map_width,map_height) 
    texture.needsUpdate = true

    spec = new THREE.DataTexture(cdata.smap.data,map_width,map_height) 
    spec.needsUpdate = true

    bumpmap = new THREE.DataTexture(cdata.bmap.data,map_width,map_height) 
    bumpmap.needsUpdate = true

    material = new THREE.MeshPhongMaterial
        map : texture
        bumpMap : bumpmap
        bumpScale:   bump_scale
        specularMap: spec
        specular: new THREE.Color('grey')
        transparent: true

    planet = new THREE.Mesh(new THREE.SphereGeometry(100, 24, 24),material)

    ##{size:64,color:5}{size:32,color:6},
    layers = [{size:64,color:5}]
    for layer in layers
      map_width = 256
      map_height = 1024
      cloud_hdata = noise(map_width,map_height,0,0,1,layer.size)
      
      cloud_cdata = cmap(cloud_hdata,layer.color)

      cloud_texture = new THREE.DataTexture(cloud_cdata.cmap.data,map_width,map_height) 
      cloud_texture.needsUpdate = true

      clouds = new THREE.Mesh new THREE.SphereGeometry(110, 24, 24),
        new THREE.MeshPhongMaterial
          map: cloud_texture
          transparent: true
          
      planet.add(clouds)    


    return planet
