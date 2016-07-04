OBJECT = require 'object'

local VIEW = OBJECT()

function VIEW:new()
    local self = OBJECT.new(self)
    self.subviews = {}
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    return self
end

function VIEW:add_subview(view)
    if not view then error('view is nil', 2) end
    if view.superview then
        view:remove_from_superview()
    end
    table.insert(self.subviews, view)
    view.superview = self
    self:refresh()
end

function VIEW:remove_from_superview()
    if not self.superview then error('superview is nil', 2) end

    local removed = false
    for i,v in ipairs(self.superview.subviews) do
        if v == self then
            table.remove(self.superview.subviews, i)
            removed = true
            break
        end
    end
    assert(removed, "superview doesnt have this view!")
    self.superview:refresh()
    self.superview = nil
end

function VIEW:refresh()
    if self.superview then
        self.superview:refresh()
    end
end

local floor = math.floor
function VIEW:render(x, y)
    x = x or 0
    y = y or 0

    x = x + self.x
    y = y + self.y
    local bg = self.background_color
    if bg then 
        FILL_RECT(floor(x), floor(y), self.width, self.height, bg[1] or 0, bg[2] or 0, bg[3] or 0, bg[4])
    end

    self:draw(x, y)

    for i, v in ipairs(self.subviews) do
        v:render(x, y)
    end
end

function VIEW:draw(x, y)
end

function VIEW:get_center()
    local center = {}
    center.x = self.x + self.width/2
    center.y = self.y + self.height/2
    return center
end

function VIEW:contains(x, y)
    return x >= 0 and x < self.width and y >= 0 and y < self.height
end
    
function VIEW:mouse(down, x, y, ...)
    x = x - self.x
    y = y - self.y
    if not down or self:contains(x, y) then
        self.leftmdown = down
    end
    local should_refresh = false
    for i,v in ipairs(self.subviews) do
        should_refresh = should_refresh or v:mouse(down, x, y, ...)
    end
    return should_refresh
end

function VIEW:drag(x, y)
    x = x - self.x
    y = y - self.y
    local should_refresh = false
    for i,v in ipairs(self.subviews) do
        should_refresh = should_refresh or v:drag(x, y)
    end
    return should_refresh
end

function VIEW:hover(x, y)
    x = x - self.x
    y = y - self.y
    for i,v in ipairs(self.subviews) do
        v:hover(x, y)
    end
end


return VIEW
