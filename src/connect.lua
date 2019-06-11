local directory = (...):match("(.-)[^%.]+$")
local Provider = require(directory..'provider')

local function assign(target, ...)
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
    if type(comp.extend) ~= 'function' then return false end
    if type(comp.new) ~= 'function' then return false end
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

local function connect(mapStateToProps)
    local store = Provider.store
    return function (comp)

        local function errFunc() end
        if store == nil then
            return errFunc
        end
        if not isComponent(comp) then
            return errFunc
        end

        return function (props)
            local obj = comp:new(props)
            local prevProps = mapStateToProps(store.getState(), obj.props)
            obj.props = assign({}, obj.props, prevProps)

            local function stateChanged()
                local nextProps = mapStateToProps(store.getState(), obj.props)
                if isPropsChanged(prevProps, nextProps) then
                    obj:reduxPropsChanged(prevProps, nextProps)
                    obj.props = assign({}, obj.props, nextProps)
                    prevProps = nextProps
                end
            end
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
