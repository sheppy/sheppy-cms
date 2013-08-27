module.exports = (grunt) ->

    # Project configuration.
    grunt.initConfig
        # Load package information
        pkg: grunt.file.readJSON "package.json"

        coffeelint:
            gruntfile: ["Gruntfile.coffee"]
            app: ["src/**/*.coffee"]
            test: ["test/**/*.coffee"]
            options:
                "no_tabs":
                    "level": "error"
                "no_trailing_whitespace":
                    "level": "error",
                    "allowed_in_comments": false
                "max_line_length":
                    "value": 130,
                    "level": "error"
                "camel_case_classes":
                    "level": "error"
                "indentation":
                    "value": 4,
                    "level": "error"
                "no_implicit_braces":
                    "level": "ignore"
                "no_trailing_semicolons":
                    "level": "error"
                "no_plusplus":
                    "level": "ignore"
                "no_throwing_strings":
                    "level": "error"
                "cyclomatic_complexity":
                    "value": 10,
                    "level": "ignore"
                "no_backticks":
                    "level": "error"
                "line_endings":
                    "level": "ignore",
                    "value": "unix"
                "no_implicit_parens":
                    "level": "ignore"
                "empty_constructor_needs_parens":
                    "level": "ignore"
                "non_empty_constructor_needs_parens":
                    "level": "ignore"
                "no_empty_param_list":
                    "level": "ignore"
                "space_operators":
                    "level": "ignore"
                "duplicate_key":
                    "level": "error"
                "newlines_after_classes":
                    "value": 3,
                    "level": "ignore"
                "no_stand_alone_at":
                    "level": "ignore"
                "arrow_spacing":
                    "level": "ignore"
                "coffeescript_error":
                    "level": "error"

        clean:
            src: ["src/**/*.js"]
            test: ["test/**/*.js"]

        coffee:
            src:
                expand: true
                flatten: true
                cwd: "src"
                src: "**/*.coffee"
                dest: "src"
                ext: ".js"
            test:
                expand: true
                flatten: true
                cwd: "test"
                src: "**/*.coffee"
                dest: "test"
                ext: ".js"

        simplemocha:
            all:
                src: [
                    "src/**/*.js"
                    "test/**/*.js"
                ]
                options:
                    reporter: "spec"
                    slow: 200
                    timeout: 1000
                    ignoreLeaks: false
                    ui: "bdd"

        watch:
            test:
                files: ["src/**/*.coffee", "test/**/*.coffee"]
                tasks: ["test"]

    # Load tasks
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-coffeelint"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-simple-mocha"

    # Register tasks
    grunt.registerTask "test", ["clean", "coffeelint", "coffee", "simplemocha", "clean"]
    grunt.registerTask "default", ["test"]