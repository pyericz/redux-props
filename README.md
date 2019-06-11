# redux-props
[![Build Status](https://api.travis-ci.org/pyericz/redux-props.svg?branch=master)](https://travis-ci.org/pyericz/redux-props)

redux-props is useful for handling [redux](https://github.com/pyericz/redux-lua) state changes.

## Installation
You can install redux-props using [LuaRocks](http://luarocks.org/modules/pyericz/redux-props):
```
luarocks install redux-props
```

## Usage
Define componet:
```lua
--[[
    File: components/handler.lua
--]]
local Component = require 'redux-props.component'
local Handler = Component:extends()

function Handler:constructor(props)
    Component.constructor(Handler, props)
    -- something else
end

-- Define a props will change handler
function Handler:reduxPropsWillChange(prevProps, nextProps)
    -- handle props will change
end

-- Define a props changed handler
function Handler:reduxPropsChanged()
    local props = self.props
    -- handle props changed
end

return Handler
```

Define container:
```lua
--[[
    File: containers/handler.lua
--]]
local connect = require 'redux-props.connect'
local handlerComp = require 'components.handler'

-- `ownProps` is optional
local function mapStateToProps(state, ownProps)
    return {
        url = state.example.url,
        flag = state.example.flag
    }
end

return connect(mapStateToProps)(handlerComp)
```

Test dispatching:
```lua
local Provider = require 'redux-props.provider'
local ExampleActions = require 'actions.example'
local Handler = require 'container.handler'

local store = ...

Provider.setStore(store)

-- create handler instance with initial props.
local props = {}
local handler = Handler(props)

store.dispatch(ExampleActions.updateUrl('https://github.com'))

-- don't forget to call `destroy` before handler is destroyed.
handler:destroy()
```

## License
[MIT License](https://github.com/pyericz/redux-props/blob/master/LICENSE)
