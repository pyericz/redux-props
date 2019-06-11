local ReduxProps = {}

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

function ReduxProps.bindStore(store)
    if type(store) ~= 'table' and store ~= nil then
        error('Unknown store type')
    end
    if type(store) == 'table' then
        assert(type(store.getState) == 'function' and
            type(store.dispatch) == 'function' and
            type(store.subscribe) == 'function', 'Invalid store.')
    end
    ReduxProps.store = store
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

function ReduxProps.connect(mapStateToProps)
    local store = ReduxProps.store
    return function (handler)

        if store == nil then
            return handler
        end
        if type(handler) ~= 'table' then
            return handler
        end
        if type(handler.reduxPropsChanged) ~= 'function' then
            return handler
        end

        local prevProps = mapStateToProps(store.getState(), handler.props)
        handler.props = assign({}, handler.props, prevProps)

        local function stateChanged()
            local nextProps = mapStateToProps(store.getState(), handler.props)
            if isPropsChanged(prevProps, nextProps) then
                handler:reduxPropsChanged(prevProps, nextProps)
                handler.props = assign({}, handler.props, nextProps)
                prevProps = nextProps
            end
        end
        local destroy = handler.destroy
        local unsubscribe = store.subscribe(stateChanged)
        handler.destroy = function (...)
            unsubscribe()
            if type(destroy) == 'function' then
                destroy(...)
            end
        end
        return handler
    end
end

return ReduxProps
