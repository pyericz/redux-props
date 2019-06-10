local combineReducers = require 'lredux.combineReducers'
local test1 = require 'spec.reducers.test1'

return combineReducers({
    test1 = test1,
})
