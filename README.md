# redux-props
[![Build Status](https://api.travis-ci.org/pyericz/redux-props.svg?branch=master)](https://travis-ci.org/pyericz/redux-props)

redux-props is useful for handling [redux](https://github.com/pyericz/redux-lua) state changes.

## Installation
You can install redux-props using [LuaRocks](http://luarocks.org/modules/pyericz/redux-props):
```
luarocks install redux-props
```

## Usage
```lua
--[[
    File: components/hanlder.lua
    Handler component definition.
--]]
local Component = require 'redux-props.component'
local Handler = Component:extend()

function Handler:constructor(props)
    Component.constructor(Handler, props)
    -- something else
end

-- Define a props changed handler
function Handler:reduxPropsChanged(prevProps, nextProps)
    -- handle props changed
end

return Handler
```

```lua
local Provider = require 'redux-props.provider'
local ExampleActions = require 'actions.example'
local handlerComp = require 'components.handler'

local store = ...

Provider.setStore(store)

-- `ownProps` is optional
local function mapStateToProps(state, ownProps)
    return {
        url = state.example.url,
        flag = state.example.flag
    }
end

local handlerContainer = connect(mapStateToProps)(handlerComp)

-- create handler instance with initial props.
local props = {}
local handler = handlerContainer(props)

store.dispatch(ExampleActions.updateUrl('https://github.com'))

-- don't forget to call `destroy` before handler is destroyed.
handler:destroy()
```

## License
[MIT License](https://github.com/pyericz/redux-props/blob/master/LICENSE)
