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
    Handler definition.
--]]
local Handler = {}

-- Define a props changed handler
function Handler:reduxPropsChanged(prevProps, nextProps)
end

return Handler
```
```lua
local ReduxProps = require 'reduxProps'
local ExampleActions = require 'actions.example'
local handler = require 'handler'

local store = ...

ReduxProps.bindStore(store)

-- `ownProps` is optional
local function mapStateToProps(state, ownProps)
    return {
        url = state.example.url,
        flag = state.example.flag
    }
end

local container = ReduxProps.connect(mapStateToProps)(handler)

store.dispatch(ExampleActions.updateUrl('https://github.com'))

container:destroy()
```

## License
[MIT License](https://github.com/pyericz/redux-props/blob/master/LICENSE)
