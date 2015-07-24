--region StarCellSprite.lua
--Author : czh
--Date   : 2015/7/21
-- 星星精灵

StarCellSprite = class(
	"StarCellSprite",
	function( ... )
		return CCSprite:create( ... )
	end
)

function StarCellSprite:initWithData( starType, rIdx, cIdx )
	self.data = {}
	self.data.starType = starType or 1
	self.data.rIdx = rIdx
	self.data.cIdx = cIdx
	self.data.isOver = false	-- 是否点中消失
	self.data.nextStep = 0		-- 点中移动的星星位数 
end

function StarCellSprite:setIsOver( isOver )
	self.data.isOver = isOver
end

function StarCellSprite:getIsOver()
	return self.data.isOver
end

function StarCellSprite:getStarType()
	return self.data.starType
end

function StarCellSprite:disappear()
	self:removeFromParentAndCleanup( true )
end

function StarCellSprite:addNextStep()
	self.data.nextStep = self.data.nextStep + 1
end

function StarCellSprite:getNextStep()
	return self.data.nextStep
end

function StarCellSprite:clearNextStep()
	self.data.nextStep =  0
end



--endregion
