module.exports = (grunt) ->

  grunt.initConfig
    #watch :
    #  src :
    #    files : ['dev/**']
    #    tasks : ['default']
    #,
    copy :
      target :
        files :
          '../client/web/site/js/': ['utils/rnd.js','utils/trig.js','utils/movement.js']
    #,
    #coffee :
    #  glob_to_multiple :
    #    expand : true
    #    flatten : false
    #    cwd: 'src'
    #    src: ['**/*.coffee']
    #    dest: 'dev'
    #    ext: '.js'

  grunt.loadNpmTasks('grunt-contrib');

  #grunt.registerTask('default', ['coffee','copy']);
