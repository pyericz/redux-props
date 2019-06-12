local Component = {}

local function suppressWarning()
    -- suppress luacheck warnings
end

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
    suppressWarning(self, prevProps, nextProps)
end

function Component:reduxPropsChanged()
    suppressWarning(self)
end

function Component:destroy()
    suppressWarning(self)
end

return Component
