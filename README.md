# Supplier

Glue for Node.js modules

```coffeescript
# require supplier module
supplier = require "supplier"

# create instance
supply = supplier()

# define own plugin
supply.use (supply, callback) ->
    # add dependent plugins
    supply.use supplier.plugins.express
    supply.use supplier.plugins.mongoose
    supply.use supplier.plugins.fixtures

    # configure
    supply.set "name", "hello world"
    supply.set "connection string", "mongodb://localhost/hello_world"
    supply.set "fixtures directory", "#{__dirname}/fixtures"

    # after all dependent is configured
    supply.on "configured", ->
        # get necessary variables
        connection = supply.get "connection"
        mongoose = supply.get "mongoose"
        app = supply.get "app"

        # define schemas
        MessageSchema = new mongoose.Schema
            message: type: "string"

        # define models
        Message = connection.model "messages", MessageSchema

        # define express routes
        app.get "/", (req, res) ->
            Message.find {}, (err, messages) ->
                res.send messages

        # our plugin is loaded, allow to start server
        callback.loaded()

    # our plugin is configured
    callback.configured()
```

## Quick Start

Start new project:

```
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

```
$ npm install supplier --save
```

Create sample application:

```
$ cat << END > my_project.coffee
supplier = require "supplier"

supply = supplier()
supply.use (supply, callback) ->
    supply.use supplier.plugins.assets
    supply.use supplier.plugins.express
    supply.set "public directory", "#{__dirname}/public"
    callback()
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

```
$ coffee my_project
```

## Viewing Examples

Clone Supplier repo, then install dependencies:

```
$ git clone git://github.com/rithis/supplier.git
$ cd supplier
$ npm install
```

Run example:

```
$ coffee examples/hello_world
```

## Project Status

Build Status: [![Build Status](https://drone.io/github.com/rithis/supplier/status.png)](https://drone.io/github.com/rithis/supplier/latest)

Dependency Status: [![Dependency Status](https://gemnasium.com/rithis/supplier.png)](https://gemnasium.com/rithis/supplier)

[Code Coverage Report](https://drone.io/github.com/rithis/supplier/files/coverage.html)

## Running Tests

Clone Supplier repo, then install dependencies:

```
$ git clone git://github.com/rithis/supplier.git
$ cd supplier
$ npm install
```

Run tests:

```
$ make test
```
