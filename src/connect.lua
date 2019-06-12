local directory = (...):match("(.-)[^%.]+$")
local Provider = require(directory..'provider')

local function assign (target, ...)
    local args = {...}
    for i=1, #args do
        local tbl = args[i] or {}
        for k, v in pairs(tbl) do
            target[k] = v
        end
    end
    return target
end

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

local function isPropsChanged(prevProps, nextProps)
    for k,v in pairs(prevProps) do
        if nextProps[k] ~= v then
            return true
        end
    end
    for k,v in pairs(nextProps) do
        if prevProps[k] ~= v then
            return true
        end
    end
    return false
end

local function handleNextProps(object, nextProps, comparison)
    if comparison and not isPropsChanged(object.props, nextProps) then return end

    object:reduxPropsWillChange(object.props, nextProps)
    object.props = nextProps
    object:reduxPropsChanged()
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

            handleNextProps(
                obj,
                assign({}, obj.props, stateProps, dispatchProps),
                true
            )

            if type(mapStateToProps) ~= 'function' then
                -- we don't need to handle state changes any more
                return obj
            end

            local function stateChanged()
                local nextStateProps = mapStateToProps(store.getState(), ownProps)
                if isPropsChanged(stateProps, nextStateProps) then
                    local nextProps = assign({}, obj.props, nextStateProps)
                    handleNextProps(obj, nextProps, false)
                    stateProps = nextStateProps
                end
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
