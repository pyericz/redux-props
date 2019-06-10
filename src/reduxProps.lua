local ReduxProps = {}

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

local function handlerCall(handler, prevProps, nextProps)
    if type(handler) == 'function' then
        handler(prevProps, nextProps)
    elseif type(handler) == 'table' then
        if type(handler.reduxPropsChanged) == 'function' then
            handler:reduxPropsChanged(prevProps, nextProps)
        end
    end
end

function ReduxProps.connect(mapStateToProps)
    local store = ReduxProps.store
    return function (handler)
        if store == nil then
            return function () end
        end
        local prevProps = mapStateToProps(store.getState())
        local function stateChanged()
            local nextProps = mapStateToProps(store.getState())
            if isPropsChanged(prevProps, nextProps) then
                handlerCall(handler, prevProps, nextProps)
                prevProps = nextProps
            end
        end
        return store.subscribe(stateChanged)
    end
end

return ReduxProps
