# Simple Inheritance Of Lua
## A lua version like JR's simple-inheritance in javascript
## By fanxl 
http://www.hippyless.com/blog/?p=9
## MIT Licensed

# Example
## Base Object

	BaseObject = Class:extend({
	
		__className = "BaseObject",
		
		init = function(self)
			print("BaseObject init")
		end,
		
		info = function(self)
			print("BaseObject info")
		end
		
	})
    
## Extend BaseObject
	FlyObject = BaseObject:extend({
	   
	    __className = "FlyObject",
		
		init = function(self,speed)
		    self.speed  = speed;
			self:_super() --super init method
			print("FlyObject init")
		end,
		
		fly = function(self)
			print("FlyObject fly with speed"..self.speed)
		end	
	})

## Override
	DuckObject  = FlyObject:extend({
	    
	    __className = "DuckObject",
	    
		init = function(self,speed,sound)
			self:_super(speed)
			self.sound = sound
			print("DuckObject init")
		end,
	
		fly = function(self) --override FlyObject
			self:_super()
			print("DuckObject fly with speed"..self.speed)
		end,
		
		info = function(self)  --override BaseObject
			self:_super()
			print("DuckObject info")
		end,
		
		sound = function(self)
			return self.sound
		end
	})
	
## Runtime type check

	liveduck = DuckObject:new(500,"gaga~gaga~")
	print("live duck is  instance of DuckObject? "..tostring(liveduck:instanceof(DuckObject)))
	print("live duck is  instance of FlyObject? "..tostring(liveduck:instanceof(FlyObject)))
	print("live duck is  instance of BaseObject? "..tostring(liveduck:instanceof(BaseObject)))
