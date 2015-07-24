--region LevelMgr.lua
--Author : czh
--Date   : 2015/7/21
-- 关卡数据管理

LevelMgr = class( "LevelMgr" )

function LevelMgr:ctor()
	self.level = {
		gameLevel = 1,		
		starTypeCount = 7,
	}

	
end

function LevelMgr:setGameLevel( gameLavel )
	self.level.gameLevel = gameLavel
end

function LevelMgr:getGameLevel()
	return self.level.gameLevel
end




--endregion
