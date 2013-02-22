cleaner = require "./utils/cleaner"
assert = require "assert"
path = require "path"
fs = require "fs"

supplier = require if process.env.COVERAGE \
    then "../lib-cov/supplier"
    else "../lib/supplier"


describe "Bower plugin", ->
    publicDirectory = null
    container = null
    loader = null

    this.timeout 0

    beforeEach (callback) ->
        container = supplier "test", __dirname
        loader = container.get "loader"

        container.set "components", ["jquery#~1.9"]
        loader.use supplier.plugins.bower

        publicDirectory = container.get "public directory"
        callback()

    afterEach (callback) ->
        cleaner container, [
            cleaner.bower
        ], callback

    it "should run bower", (callback) ->
        loader.once "loaded", ->
            componentsDirectory = path.join publicDirectory, "components"
            jqueryDirectory = path.join componentsDirectory, "jquery"
            fs.stat jqueryDirectory, (err, stats) ->
                assert.ok stats.isDirectory()
                callback()

    it "should pipe bower output", (callback) ->
        container.set "silent", false

        message = ""
        write = process.stdout.write
        process.stdout.write = (data) ->
            message += data.toString()

        loader.once "loaded", ->
            assert.ok message.indexOf("bower") >= 0

            process.nextTick ->
                process.stdout.write = write
                callback()
