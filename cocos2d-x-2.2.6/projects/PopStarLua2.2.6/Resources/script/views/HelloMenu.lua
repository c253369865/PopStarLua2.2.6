--region HelloMenu.lua
--Author : czh
--Date   : 2015/7/14
-- 主菜单

HelloMenuLayer = class(
	"HelloMenuLayer",
	function()
		return CCLayer:create()
	end
)

-- override CCLayer::setVisible
function HelloMenuLayer:setVisible(visible)
    -- invoke CCLayer::setVisible
    getSuperMethod(self, "setVisible")(self, visible)
    -- to do something.
end

function HelloMenuLayer:ctor( x, y, z )
	--self:initBackground()
	self:initMenu()
end

function HelloMenuLayer:initBackground()
	local bgSprite = CCSprite:create( resPath.BG1 )
	LayerUtil.setSpriteInCenter( bgSprite )
	self:addChild( bgSprite )
end

function HelloMenuLayer:initMenu()
	local menu = CCMenu:create()
	menu:setPosition( CCPointZero )

	local startMenuItem = CCMenuItemFont:create( "start" )
	startMenuItem:registerScriptTapHandler( self.startMenuClick )
	startMenuItem:setPosition( VisibleRect:center() )
	menu:addChild( startMenuItem )

	self:addChild( menu )
end

function HelloMenuLayer:startMenuClick()
	--print( "start click" )
	require( "script/views/PlayLayer" )
	LayerUtil.replaceLayer( PlayLayer:new() )
end





--endregion
