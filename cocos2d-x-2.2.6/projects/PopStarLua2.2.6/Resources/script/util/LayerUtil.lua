--region LayerUtil.lua
--Author : czh
--Date   : 2015/7/20
-- 界面辅助

LayerUtil = {}

function LayerUtil.runLayer( layer )
	local scene = CCScene:create()
	scene:addChild( layer )
	CCDirector:sharedDirector():runWithScene( scene )
end

function LayerUtil.replaceLayer( layer )
	local scene = CCScene:create()
	scene:addChild( layer )
	CCDirector:sharedDirector():replaceScene( scene )
end

function LayerUtil.setSpriteInCenter( sprite )
	sprite:setPosition( VisibleRect:center() )
	local size = sprite:getContentSize()
	local winSize = VisibleRect:getWinSize()
	sprite:setScaleX( winSize.width / size.width )
	sprite:setScaleY( winSize.height / size.height )
end



--endregion
