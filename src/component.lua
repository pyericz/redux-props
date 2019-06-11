local Component = {}

function Component:constructor(props)
    self.props = props
end

function Component:extend()
    local class = {}
    setmetatable(class, self)
    self.__index = self
    return class
end

function Component:new(props)
    local obj = {}
    obj.extend = function ()
        error('attempt to extend from an instance')
    end
    setmetatable(obj, self)
    self.__index = self
    obj:constructor(props)
    return obj
end

function Component:reduxPropsChanged(prevProps, nextProps)
    -- suppress luacheck warning
    local _, _, _ = self, prevProps, nextProps
end

function Component:destroy()
    -- suppress luacheck warning
    local _ = self
end

return Component
