h2ash
=====

Server Side
-----------
Planets/Moons
* Add geology
* Update atmosphere genartion to include atmospheric composition - number of moons and age
* Add min/max temp based on semi-major/minor axis based on random ecentricity of orbit
* Add better orbital placement
* Add age of planet?
* Add rotational period of planet
* Add orbital speed 
* Add rings to some gas giants
* Add position in orbit

Stars
* Add age
* Add binary star systems
* Add check fo stars in the instability region of the HR diagram
* Devise a naming convention ?  Quadrant (Along the z azis-phi),Sector (along the r), Region (along thxy plane, theta, 0 is on the plane , 6 regions above and 6 below)
  Delta Quadrant, Alpha Sector, Reqion 2, M18 - Further out Sectors will be more spacely populated and bigger?


General
* Change astronomy module to be more generic and then update the nox models use the new general astronomy
* Build a complete habitability check based on dole/azimov into astronomy
* Build simple routine to move planet in ellipse around planet based on some update frequency no update by batch process. Updated only when somebodu reuires the planet and thenits updated. Base on the last update?

nox
* Change nox to generate only one level deep based on directives
* Change nox to allow 'perpping' of a template on construction - ie all fields passed into the construct is used insetad of the ones in the model
* Change nox to continue generation after loading a class into a module instead of constructing
* Add more tests to nox

Service
* Add call to get all the stars (Coordinates,Name,Wavelength) 

Client
------
* Build way to convert from wavelength to RGB color
* Build query for stars 


