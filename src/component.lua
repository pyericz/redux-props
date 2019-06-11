local Component = {}

function Component:constructor(props)
    local propsType = type(props)
    assert(propsType == 'table' or propsType == 'nil',
        string.format('invalid props type (a %s value)', propsType))
    self.props = props or {}
end

function Component:extends()
    local class = {}
    setmetatable(class, self)
    self.__index = self
    return class
end

function Component:new(props)
    local obj = {}
    obj.extends = function ()
        error('attempt to extends from an instance')
    end
    obj.new = function ()
        error('attempt to create instance from an instance')
    end
    setmetatable(obj, self)
    self.__index = self
    obj:constructor(props)
    return obj
end

function Component:reduxPropsWillChange(prevProps, nextProps)
    -- suppress luacheck warning
    local _, _, _ = self, prevProps, nextProps
end

function Component:reduxPropsChanged()
    -- suppress luacheck warning
    local _ = self
end

function Component:destroy()
    -- suppress luacheck warning
    local _ = self
end

return Component
