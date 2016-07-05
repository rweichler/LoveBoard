OBJC = require 'objc'
local ffi = require 'ffi'

--localize classes
local NSDictionary = OBJC.class("NSDictionary")
local NSString = OBJC.class("NSString")
local NSArray = OBJC.class("NSArray")
local NSNumber = OBJC.class("NSNumber")
--localize selectors
local dictWithFile = OBJC.SEL("dictionaryWithContentsOfFile:")
local valForKey = OBJC.SEL("valueForKey:")
local objAtIndex = OBJC.SEL("objectAtIndex:")
local isKindOfClass = OBJC.SEL("isKindOfClass:")
local UTF8String = OBJC.SEL("UTF8String")
local floatValue = OBJC.SEL("floatValue")

local dict_mt = {}
local arr_mt = {}

local function is_class(id, class)
    return OBJC.msg("bool, id, id, id", id, isKindOfClass, class)
end

local function make_dict(id)
    local result = {}
    result.__id = id
    setmetatable(result, dict_mt)
    return result
end

local function make_arr(id)
    local result = {}
    result.__id = id
    setmetatable(result, arr_mt)
    return result
end

local function convert(id)
    if not id then return end

    if is_class(id, NSString) then
        local u = OBJC.msg("const char*,id,id", id, UTF8String)
        return ffi.string(u)
    elseif is_class(id, NSDictionary) then
        return make_dict(id)
    elseif is_class(id, NSArray) then
        return make_arr(id)
    elseif is_class(id, NSNumber) then
        return OBJC.msg("float, id, id", id, floatValue)
    end
end


dict_mt.__index = function(self, key)
    local str = OBJC.NSString(key)
    local val = OBJC.msg("id,id,id,id", self.__id, valForKey, str)
    OBJC.release(str)
    return convert(val)
end

arr_mt.__index = function(self, key)
    local val = OBJC.msg("id,id,id,int", self.__id, objAtIndex, key-1)
    return convert(val)
end

arr_mt.__len = function(self)
    return OBJC.msg("int,id,id", self.__id, OBJC.SEL("count"))
end

return function(path)
    local str = OBJC.NSString(path)
    local dict = OBJC.msg("id,id,id,id", NSDictionary, dictWithFile, str)
    OBJC.release(str)
    return make_dict(dict)
end
