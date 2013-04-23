---
-- Simple Lua Inheritance
-- By fanxl  http://confluence.redatoms.net/pages/viewpage.action?pageId=5013621
-- MIT Licensed



--- define ClassObject
Class = {
	__className = "Class",
	__type = "class"
}

---
-- @param t
--
-- define a extend method for the base ClassObject
-- params: t ,a ClassObject
-- return: a ClassObject extend the self's attributes and method,and also contains attributes and method of t
function Class:extend(t)
	--- 检查子类的定义是否符合规则
	local function checkclass(t)
		if not (t.__className and type(t.__className) == 'string') then
			 error("The T must have a string property className and must as same as the ClassObject Definition",1)
			 return 1
		end
		return 0
	end
	
	if checkclass(t)==1 then return nil end
	
	local NewClass = t or {}
	
	setmetatable(NewClass,{__index = self})
	
	---
	-- rewrite the method in a closure and export the super's method in the function context
	local _supero = self
        for k,v in pairs(t) do
            if type(t[k]) == "function" then 
        	local tempfunc = t[k];
    		if _supero[k] and type(_supero[k]) == "function" then
			NewClass[k] = function(that,...)
				that._super = _supero[k]
				ret = tempfunc(that,unpack(arg))
				that._super = nil
				return ret
			end
		else
			NewClass[k] = function(that,...)
				that._super = function(them,...) 
				end
				ret = tempfunc(that,unpack(arg))
				that._super = nil
				return ret
			end
		end  	
            end
        end
	
	return NewClass
end

---
-- @param ...
--
-- new method ,this method will return a instance of self(ClassObject)
-- default constructor method is init,it will be called after instance have a ClassObject prototype
-- the args passed to new method ,will be passed to the init method
function Class:new(...)
	local instance = {
	   __type = 'object'
	}
	setmetatable(instance,{__index = self})
	instance:init(unpack(arg))
	return instance
end


---
-- Type check during the runtime
-- @param ClassObject
--
function Class:instanceof(ClassObject)
    if Class:isClassObject(self) then error("you can't call this method on ClassObject",1)  return false end
	if Class:isInstanceObject(self) then return self:_instanceof(self,ClassObject) end
	return false
end

---
-- inner method of the instanceof
-- it will check the prototype object of the current recursivly
-- until find one as same as the given ClassObject or nil
-- @param t
-- @param ClassObject
--
--
function Class:_instanceof(t,ClassObject)
	prototype = getmetatable(t)
	if prototype then
		parentProtoType = prototype.__index
		if parentProtoType and parentProtoType == ClassObject then return true else return self:_instanceof(parentProtoType,ClassObject) end
	else
		return false;
	end
end

function Class:isClassObject(t) return t and t.__type and type(t.__type) == 'string' and t.__type=="class"  end

function Class:isInstanceObject(t) return t and t.__type and type(t.__type) == 'string' and t.__type=="object"  end



