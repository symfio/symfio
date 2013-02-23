assert = require "assert"

supplier = require if process.env.COVERAGE \
    then "../lib-cov/supplier"
    else "../lib/supplier"


describe "Supplier", ->
    it "should configure container", ->
        applicationDirectory = __dirname
        fixturesDirectory = "#{__dirname}/fixtures"
        uploadsDirectory = "#{__dirname}/public/uploads"
        publicDirectory = "#{__dirname}/public"

        nodeEnv = process.env.NODE_ENV
        process.env.NODE_ENV = "production"
        container = supplier "test", applicationDirectory

        assert.equal "test", container.get "name"
        assert.equal applicationDirectory, container.get "application directory"
        assert.equal fixturesDirectory, container.get "fixtures directory"
        assert.equal uploadsDirectory, container.get "uploads directory"
        assert.equal publicDirectory, container.get "public directory"
        assert.equal false, container.get "silent"
        assert.ok container.get "logger"
        assert.ok container.get "loader"

        process.env.NODE_ENV = "test"
        container = supplier "test", __dirname

        assert.equal true, container.get "silent"

        process.env.NODE_ENV = nodeEnv
