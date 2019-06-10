# redux-props
[![Build Status](https://api.travis-ci.org/pyericz/redux-props.svg?branch=master)](https://travis-ci.org/pyericz/redux-props)

redux-props is useful for handling [redux](https://github.com/pyericz/redux-lua) state changes.

## Installation
You can install redux-props using [LuaRocks](http://luarocks.org/modules/pyericz/redux-props):
```
luarocks install redux-props
```

## Usage
### Handler is a function
```lua
local ReduxProps = require 'reduxProps'
local ExampleActions = require 'actions.example'

local store = ...

ReduxProps.bindStore(store)

local function mapStateToProps(state)
    return {
        url = state.example.url,
        flag = state.example.flag
    }
end

-- Define a props changed handler
local function handler(prevProps, nextProps)
end

local disconnect = ReduxProps.connect(mapStateToProps)(handler)

store.dispatch(ExampleActions.updateUrl('https://github.com'))

disconnect()
```

### Handler is an object
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
local Handler = require 'handler'

local store = ...

ReduxProps.bindStore(store)

local function mapStateToProps(state)
    return {
        url = state.example.url,
        flag = state.example.flag
    }
end

local disconnect = ReduxProps.connect(mapStateToProps)(Handler)

store.dispatch(ExampleActions.updateUrl('https://github.com'))

disconnect()
```

## License
[MIT License](https://github.com/pyericz/redux-props/blob/master/LICENSE)
