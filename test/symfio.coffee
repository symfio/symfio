symfio = require ".."
chai = require "chai"


describe "symfio()", ->
  chai.use require "chai-as-promised"
  chai.should()

  it "should return new symfio.Symfio()", ->
    container = symfio "test", __dirname
    container.should.be.instanceOf symfio.Symfio

  describe "Symfio", ->
    it "should return configured container", (callback) ->
      container = new symfio.Symfio "test", __dirname

      container.get([
        "name"
        "applicationDirectory"
        "env"
        "logger"
        "kantaina"
        "w"
      ]).spread (name, applicationDirectory, env, logger, kantaina, w) ->
        name.should.equal "test"
        applicationDirectory.should.equal __dirname
        env.should.equal "development"
        logger.should.be.a "object"
        kantaina.should.equal require "kantaina"
        w.should.equal require "when"
      .should.notify callback

    it "should use NODE_ENV as env", (callback) ->
      process.env.NODE_ENV = "production"
      container = new symfio.Symfio "test", __dirname

      container.get("env").then (env) ->
        env.should.equal "production"
      .should.notify callback

    describe "#require()", ->
      it "should set module", (callback) ->
        container = symfio "test", __dirname
        container.require "chai"
        container.get("chai").should.eventually.equal(chai).and.notify callback

      it "should set module to different key", (callback) ->
        container = symfio "test", __dirname
        container.require "c", "chai"
        container.get("c").should.eventually.equal(chai).and.notify callback

    describe "#injectAll()", ->
      it "should inject all plugins", (callback) ->
        pluginA = (container) ->
          container.set "a", 1

        pluginB = (container) ->
          container.set "b", (a) ->
            a + 1

        pluginC = (container) ->
          container.set "c", (a, b) ->
            a + b

        container = symfio "test", __dirname

        container.injectAll([
          pluginC
          pluginB
          pluginA
        ]).then ->
          container.get "c"
        .then (c) ->
          c.should.equal 3
        .should.notify callback

    describe "#clean()", ->
      it "should clean container", (callback) ->
        container = symfio "test", __dirname
        container.set "name", "mest"
        container.inject (name) ->
          name.should.equal "mest"
          container.clean()
          container.get ["name", "w"]
        .spread (name, w) ->
          name.should.equal "test"
          w.should.equal require "when"
        .should.notify callback
