--[[
	tests.lua
	=========

	Defines the unit tests for the LLBase
]]


-- [[ LLBase tests ]]
describe("LLBase", function()

	local count = 0
	local clr = require 'trepl.colorize'

  -- Crete the printing function
  	local function ll(message)
      print(clr.red("[") .. clr.Blue("Test #" .. count) .. clr.red("]") .. "{ ".. message .. " }")
	end
	
	before_each(function()
		print("")
		count = count + 1
		ll("---> Starting LLBase test #" .. count)
	end)

	after_each(function()
		print(" -> Done testing")
	end)

	it("should print in colors", function()
		ll("Hola")
	end)

	it("should import the module", function()
		local Base = require("LLBase.ObjectFactory")
		assert.truthy(Base)
	end)

end)

--[[ Object Factory tests]]
describe("ObjectFactory", function()
	local count = 0
	local clr = require 'trepl.colorize'

	  -- Crete the printing function
  	local function ll(message)
      print(clr.red("[") .. clr.Blue("Test #" .. count) .. clr.red("]") .. "{ ".. message .. " }")
	end

	before_each(function()
		print("")
		count = count + 1
		ll("---> Starting Object Factory test #" .. count)
	end)

	describe("when creating new instances,", function() 
		it("should allocate", function()
			local Factory = require("LLBase.ObjectFactory")
			assert.truthy(Factory)

			local newInsance = Factory:new(fakeImg, 100, 200)

			assert.truthy(newInstance)
			assert.are.same(newInstance.x, 100)
			assert.are.same(newInstance.y, 200)
		end)
		it("should fail for bad parameters", function()
			local Factory = require("LLBase.ObjectFactory")
			assert.truthy(Factory)

			local obj2 = Factory:new(nil, nil, nil)
			assert.falsy(obj2)

			local obj3 = Factory:new(nil, 1, 1)
			assert.falsy(obj3)

			local obj4 = Factory:new(nil, nil, 0)
			assert.falsy(obj4)
		end)
	end)
end)