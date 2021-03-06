/*global module:false*/

module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
    concat: {
      js: {
        options: {
          separator: '',
          stripBanners: {
            block: true,
            line: true,
          },
        },
        expand: true,
        cwd: 'js',
        src: ['*.js', '!*.min.js'],
        dest: 'js',
        ext: '.min.js',
      },
      css: {
        options: {
          separator: '',
          stripBanners: {
            block: true,
            line: true,
          },
        },
        expand: true,
        cwd: 'css',
        src: ['*.css', '!*.min.css'],
        dest: 'css',
        ext: '.min.css'
      }
    },
    uglify: {
      dist: {
        options: {
          mangle: {
            reserved: ['jQuery']
          },
        },
        files: [{
          expand: true,
          cwd: 'js',
          src: ['*.js', '!*min.js'],
          dest: 'js',
          ext: '.min.js',
        }],
      }
    },
    cssmin: {
      dist: {
        files: [{
          expand: true,
          cwd: 'css',
          src: ['*.css', '!*.min.css'],
          dest: 'css',
          ext: '.min.css'
            }]
      },
    },
    minify: {
      js: {

      },
      css: {

      },
    },
    jshint: {
      dev: ['js/**/*.js', '!**/*.min.js']
    },
    clean: {
      dist: ['*.min.*', 'css/**/*.min.*', 'js/**/*.min.*']
    },
  });

  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-qunit');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');

  grunt.registerTask('default', function(){
    grunt.log.writeln('default');
  });
  grunt.registerMultiTask('minify', function(){
    switch (this.target) {
      case 'js':
        grunt.task.run('concat:js');
        grunt.task.run('uglify:dist')
        break;
      case 'css':
        grunt.task.run('concat:css');
        grunt.task.run('cssmin:dist');
        break;
    }
  });
};
