# Supplier

Glue for Node.js modules

```coffeescript
# require supplier module
supplier = require "supplier"

# create container
container = supplier "hello world"
loader = container.get "loader"

# add dependent plugins
loader.use supplier.plugins.express
loader.use supplier.plugins.mongoose
loader.use supplier.plugins.fixtures

# define own plugin
loader.use (container, callback) ->
    # configure
    container.set "connection string", "mongodb://localhost/hello_world"
    container.set "fixtures directory", "#{__dirname}/fixtures"

    # after all dependencies is injected in container
    loader.once "injected", ->
        # get dependencies
        connection = container.get "connection"
        mongoose = container.get "mongoose"
        app = container.get "app"

        # define schemas
        MessageSchema = new mongoose.Schema
            message: type: "string"

        # define models
        Message = connection.model "messages", MessageSchema

        # define express routes
        app.get "/", (req, res) ->
            Message.find {}, (err, messages) ->
                res.send messages

        # our plugin is configured and loaded, allow to start server
        callback.configured()
        callback.loaded()

    # our plugin injected values in container
    callback.injected()
```

## Quick Start

Start new project:

```sh
$ mkdir my_project
$ cd my_project
$ git init
$ cat << END > .gitignore
node_modules
END
$ cat << END > package.json
{
    "name": "my_project",
    "version": "0.0.0",
    "public": false
}
END
```

Install Supplier:

```sh
$ npm install supplier --save
```

Create sample application:

```sh
$ cat << END > my_project.coffee
supplier = require "supplier"

container = supplier()
container.set "public directory", "#{__dirname}/public"
loader = container.get "loader"
loader.use supplier.plugins.assets
loader.use supplier.plugins.express
END
$ mkdir public
$ cat << END > public/index.jade
doctype 5
html
    head
        title Hello World!
    body
        h1 Hello World!
END
```

Start server:

```sh
$ coffee my_project
```

## Viewing Examples

Clone Supplier repo, then run example:

```sh
$ git clone git://github.com/rithis/supplier.git
$ cd supplier
$ make example
```

## Project Status

[![Build Status](https://drone.io/github.com/rithis/supplier/status.png)](https://drone.io/github.com/rithis/supplier/latest) [![Dependency Status](https://gemnasium.com/rithis/supplier.png)](https://gemnasium.com/rithis/supplier)

[Code Coverage Report](http://rithis.github.com/supplier/coverage.html)

[Latest Documentation](http://rithis.github.com/supplier/docs/supplier.html)

## Running Tests

Clone Supplier repo, then run tests:

```sh
$ git clone git://github.com/rithis/supplier.git
$ cd supplier
$ make test
```
