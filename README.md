# redux-props

redux-props is useful for handling [redux](https://github.com/pyericz/redux-lua) state changes.

## Installation
You can install redux-props using LuaRocks
```
luarocks install redux-props
```

## Usage
```lua
local store = require 'store'
local ReduxProps = require 'reduxProps'
local ExampleActions = require 'actions.example'

ReduxProps.bind(store)

local function mapStateToProps(state)
    return {
        url = state.example.url,
        flag = state.example.flag
    }
end

local function handler(prevProps, nextProps)
end

local disconnect = ReduxProps.connect(mapStateToProps)(handler)

store.dispatch(ExampleActions.updateUrl('https://github.com'))

disconnect()
```
