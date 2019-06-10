local ReduxProps = require 'src.reduxProps'
local reducers = require 'spec.reducers.index'
local createStore = require 'lredux.createStore'
local Test1Actions = require 'spec.actions.test1'

local store = createStore(reducers)

describe('ReduxProps', function ()
    describe('store', function ()
        it('bind store', function ()
            assert.has_error(function()
                ReduxProps.bindStore(function() end)
            end)
            assert.has_error(function()
                ReduxProps.bindStore({})
            end)
            assert.has_error(function()
                ReduxProps.bindStore(1)
            end)
            assert.has_no.errors(function()
                ReduxProps.bindStore(store)
            end)
            assert.has_no.errors(function()
                ReduxProps.bindStore(nil)
            end)
        end)
        it('connect', function ()
            ReduxProps.bindStore(store)
            local function mapStateToProps(state)
                return {
                    title = state.test1.title,
                    num = state.test1.num
                }
            end

            local index = 1
            local function handler(prev, next)
                print('[TITLE]', prev.title, next.title)
                print('[NUM]', prev.num, next.num)
                index = index + 1
            end
            local disconnect = ReduxProps.connect(mapStateToProps)(handler)

            store.dispatch(Test1Actions.updateTitle('GitHub'))
            assert.is_equal(index, 2)

            store.dispatch(Test1Actions.updateUrl('https://github.com'))
            assert.is_equal(index, 2)

            store.dispatch(Test1Actions.updateFlag(true))
            assert.is_equal(index, 2)

            store.dispatch(Test1Actions.updateTitle('Redux'))
            assert.is_equal(index, 3)

            store.dispatch(Test1Actions.updateNum(index))
            assert.is_equal(index, 4)

            store.dispatch(Test1Actions.updateUrl('https://redux.js.org'))
            assert.is_equal(index, 4)

            disconnect()
            ReduxProps.bindStore(nil)
        end)
    end)
end)
