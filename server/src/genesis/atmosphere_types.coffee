types = require './types'


NO_ATMOSPHERE = 
  name : types.fixed { value : 'No Atmosphere' }
  pressure : types.fixed { value : -4}
  temperature_modifier : types.fixed { value : 1 }

VERY_THIN_ATMOSPHERE =
  name : types.fixed { value : 'Very Thin Atmosphere' }
  pressure : types.range
    from       : -3
    to         : -2
  temperature_modifier : types.fixed { value : 1.2}

THIN_ATMOSPHERE =
  name : types.fixed { value : 'Thin Atmosphere' }
  pressure : types.range
    from       : -2
    to         : -1
  temperature_modifier : types.fixed { value : 1.5}

NORMAL_ATMOSPHERE =
  name : types.fixed { value : 'Earth Standard Atmosphere' }
  pressure : types.range
    from       : -1
    to         : 2
  temperature_modifier : types.fixed { value : 3}

THICK_ATMOSPHERE =
  name : types.fixed { value : 'Thick Atmosphere' }
  pressure : types.range
    from       : 2
    to         : 4
  temperature_modifier : types.fixed { value : 4}

VERY_THICK_ATMOSPHERE =
  name : types.fixed { value : 'Very Thick Atmosphere' }
  pressure : types.range
    from       : 4
    to         : 7
  temperature_modifier : types.fixed { value : 8}

module.exports = 
  NO_ATMOSPHERE : NO_ATMOSPHERE
  VERY_THIN_ATMOSPHERE : VERY_THIN_ATMOSPHERE
  THIN_ATMOSPHERE : THIN_ATMOSPHERE
  NORMAL_ATMOSPHERE : NORMAL_ATMOSPHERE
  THICK_ATMOSPHERE : THICK_ATMOSPHERE
  VERY_THICK_ATMOSPHERE : VERY_THICK_ATMOSPHERE
