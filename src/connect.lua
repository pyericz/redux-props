local directory = (...):match("(.-)[^%.]+$")
local Provider = require(directory .. 'provider')

local function isComponent(comp)
    if type(comp) ~= 'table' then return false end
    if type(comp.constructor) ~= 'function' then return false end
    if type(comp.extends) ~= 'function' then return false end
    if type(comp.new) ~= 'function' then return false end
    if type(comp.reduxPropsWillChange) ~= 'function' then return false end
    if type(comp.reduxPropsChanged) ~= 'function' then return false end
    if type(comp.destroy) ~= 'function' then return false end
    return true
end

local function connect(mapStateToProps, mapDispatchToProps)
    local store = Provider.store
    return function (comp)

        local function errFunc() end
        if store == nil then
            return errFunc
        end
        if not isComponent(comp) then
            return errFunc
        end

        return function (ownProps)
            local obj = comp:new(ownProps)

            local dispatchProps = {}
            local stateProps = {}
            if type(mapDispatchToProps) == 'function' then
                dispatchProps = mapDispatchToProps(store.dispatch, ownProps)
            end

            if type(mapStateToProps) == 'function' then
                stateProps = mapStateToProps(store.getState(), ownProps)
            end

            obj:setReduxProps(stateProps, dispatchProps)

            if type(mapStateToProps) ~= 'function' then
                -- we don't need to handle state changes any more
                return obj
            end

            local function stateChanged()
                ownProps = obj:getOwnProps()
                stateProps = mapStateToProps(store.getState(), ownProps)
                obj:setReduxProps(stateProps, dispatchProps)
            end

            -- wrap `destroy` function to call `unsubscribe` function
            local destroy = obj.destroy
            local unsubscribe = store.subscribe(stateChanged)
            obj.destroy = function (...)
                unsubscribe()
                if type(destroy) == 'function' then
                    destroy(...)
                end
            end
            return obj
        end
    end
end

return connect
