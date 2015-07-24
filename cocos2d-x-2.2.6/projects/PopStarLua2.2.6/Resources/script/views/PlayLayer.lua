--region PlayLayer.lua
--Author : czh
--Date   : 2015/7/20
-- 游戏界面

require( "script/views/StarCellSprite" )

PlayLayer = class( 
	"PlayLayer", 
	function()
		return CCLayer:create()
	end
)

-- 成员变量都在此定义
function PlayLayer:ctor()
	self.view = {}
	self.data = {}
	self.data.cells = {}
	self.data.overCells = {}
	self.data.needCheckCells = {}
	self.data.curScore = 0
	self.data.goalScore = 1000

	self.view.bgSprite = CCSprite:create( resPath.BG1 )
	self.view.playerLayer = CCLayer:create()
	self.view.uiLayer = CCLayer:create()

	self:initBackgroup()
	self:initPlayLayer()
	self:initUILayer()
end

function PlayLayer:initBackgroup()
	LayerUtil.setSpriteInCenter( self.view.bgSprite )
	self:addChild( self.view.bgSprite )
end

function PlayLayer:initPlayLayer()
	self:addChild( self.view.playerLayer )

	local cow = GameDefine.cellColCount
	local rol = GameDefine.cellRowCount
	local cellSize = ( VisibleRect:getWinWidth() - GameDefine.leftWidthGap*2 - (cow-1)*GameDefine.cellGap ) / cow
	self.data.cellSize = cellSize
	local x, y = GameDefine.leftWidthGap + cellSize/2, GameDefine.beginY + cellSize/2
	for rindx = 1, rol do 
		if not self.data.cells[rindx] then
			self.data.cells[rindx] = {}
		end
		for cindx = 1, cow do
			local starType = math.random( GameDefine.starType.minType, GameDefine.starType.maxType )
			local sprPath = string.format( resPath.STAR, starType )
			local starCellSprite = StarCellSprite:new( sprPath )
			starCellSprite:initWithData( starType, rindx, cindx )
			self.data.cells[rindx][cindx] = starCellSprite
			self.view.playerLayer:addChild( starCellSprite )
			starCellSprite:setPosition( CCPoint( x, y ) )
			local size = starCellSprite:getContentSize()
			starCellSprite:setScaleX( cellSize / size.width )
			starCellSprite:setScaleY( cellSize / size.height )
			
			y = y + cellSize + GameDefine.cellGap
		end
		x = x + cellSize + GameDefine.cellGap
		y = GameDefine.beginY + cellSize/2
	end

	self:initPlayLayerTouch()

end

function PlayLayer:initPlayLayerTouch()
	
	local function onTouchEnded(x, y)
		local pos = CCPoint( x, y )
		for rIdx, rowCells in pairs( self.data.cells ) do 
			--print( "rIdx", rIdx )
			local find = false

			for cIdx, cell in pairs( rowCells ) do 
				local rect = cell:boundingBox()
				if rect:containsPoint( pos ) then
					--print( "--------find-------" )
					cell:setIsOver( true )
					self.data.overCells = {}
					self.data.needCheckCells = {}
					table.insert( self.data.overCells, cell )
					table.insert( self.data.needCheckCells, cell )
					self:checkAllCells( cell:getStarType() )
					--self:checkOverCells( cell:getStarType(), cell.data.rIdx, cell.data.cIdx )
--					for k, v in pairs( cell.data ) do 
--						print( k, v )
--					end
					find = true
					break
				end
			end
			if find then
				break
			end
		end
	end

	local function onTouch( eventType, x, y )
		if eventType == "began" then
			return true
		elseif eventType == "ended" then
			return onTouchEnded( x, y )
		end
	end

	self.view.playerLayer:setTouchEnabled( true )
	self.view.playerLayer:registerScriptTouchHandler( onTouch )
end


function PlayLayer:checkAllCells( starType )
	while #self.data.needCheckCells > 0 do
		local cell = self.data.needCheckCells[1]
		self:checkOverCells( starType, cell.data.rIdx, cell.data.cIdx )
		table.remove( self.data.needCheckCells, 1 )
	end

	print( " --------- ok 1 --------- " )
	for k, cell in pairs( self.data.overCells ) do 
		print( "over ", cell.data.rIdx, cell.data.cIdx )
	end
	print( " --------- ok 2 --------- " )

	if #self.data.overCells >= GameDefine.minOverCount then
		local score = 5
		--[[
		for k, cell in pairs( self.data.overCells ) do
			local rIdx = cell.data.rIdx
			local cIdx = cell.data.cIdx 
			self:createFlyScore( ccp( cell:getPosition() ), score )
			self.data.cells[rIdx][cIdx] = nil

--			-- 填补空白
--			for i = cIdx+1, GameDefine.cellRowCount do 
--				local upCell = self.data.cells[rIdx][i]
--				if upCell and not upCell:getIsOver() then
--					upCell:addNextStep()
--					self.data.cells[rIdx][i-1] = upCell
--					self.data.cells[rIdx][i] = nil
--				end
--			end

			cell:disappear()
			score = score + 5
		end
		]]

		local count = 0
		for ridx = 1, GameDefine.cellRowCount do 
			print( ' -- 行检查 '.. ridx )
			for cidx = GameDefine.cellColCount, 1, -1 do
				local cell = nil
				if self.data.cells[ridx] then
					cell = self.data.cells[ridx][cidx]
				end
				if cell then
					print( string.format( ' ---- 存在行%d 列%d ', ridx, cidx ) )
					if cell:getIsOver() then
						score = score + 5
						count = count + 1
						print( string.format( ' ------ 移除节点%d 行%d 列%d ', count, ridx, cidx ) )
						cell:disappear()
						self.data.cells[ridx][cidx] = nil

						-- 下移上面的星星
						local downIdx = cidx + 1
						local downCell = self.data.cells[ridx][downIdx]
						while downCell do
							print( string.format( ' -------- 下移节点 行%d 列%d ', ridx, downIdx) )
							-- 动画


							self.data.cells[ridx][downIdx-1] = downCell
							self.data.cells[ridx][downIdx] = nil

							downIdx = downIdx + 1
							downCell = self.data.cells[ridx][downIdx]
						end

						-- 右移右边的星星
						local hasThisRow = false
						for i = 1, GameDefine.cellColCount do
							if self.data.cells[ridx][i] then
								hasThisRow = true
							end
						end
						if not hasThisRow then
							print( string.format( ' -------- 删除行 行%d', ridx) )
							self.data.cells[ridx] = nil

							local leftIdx = ridx + 1
							local leftRow = self.data.cells[leftIdx]
							while leftRow do
								print( string.format( ' -------- 右移行 行%d', leftIdx) )
								-- 动画
								local moveLeftCellIdx = 1
								local moveLeftCell = leftRow[moveLeftCellIdx]
								while moveLeftCell do
--									moveLeftCell:stopAllActions()
--									local x = GameDefine.leftWidthGap + self.data.cellSize/2 + ( moveLeftCell:getContentSize().width + GameDefine.cellGap ) * (ridx-1)
--									cell:runAction( CCMoveBy:create( 1*nextStep, ccp( 0, -yBy ) ) )
								end

								self.data.cells[leftIdx-1] = leftRow
								self.data.cells[leftIdx] = nil
							end
						end
					end
				end
			end
		end
	end

	-- 检查此关卡是否结束
	-- 可以把剩下的所有星星都加入到 needCheckCells，然后检查，每次检查一个都判断一下overCells是否为空，不为空就代表是还有，游戏继续
	for rIdx = 1, GameDefine.cellRowCount do
		for cIdx = 1, GameDefine.cellColCount do 

		end
	end

	-- 下移上面的星星
--	for rIdx, rowCells in pairs( self.data.cells ) do 
--		for cIdx, cell in pairs( rowCells ) do 
--			if cell then
--				local nextStep = cell:getNextStep()
--				if nextStep > 0 then
--					local yBy = ( cell:getContentSize().height + GameDefine.cellGap ) * nextStep
--					cell:runAction( CCMoveBy:create( 1*nextStep, ccp( 0, -yBy ) ) )
--				end
--				cell:clearNextStep()
--			end
--		end
--	end

	self.data.overCells = {}
	self.data.needCheckCells = {}
end

function PlayLayer:createFlyScore( pos, score )
	local scoreLab = CCLabelTTF:create( tostring( score ), "", 32 )
	scoreLab:setPosition( pos )
	self.view.uiLayer:addChild( scoreLab )

	local overPos = ccp( self.view.curScoreLab:getPosition() )

	local arr = CCArray:create()
	arr:addObject( CCMoveTo:create( 1, overPos ) )

	local function addCurScoreCallback( node )
		self.data.curScore = self.data.curScore + score
		self.view.curScoreLab:setString( self.data.curScore )

		node:removeFromParentAndCleanup( true )
	end

	arr:addObject( CCCallFuncN:create( addCurScoreCallback ) )
	scoreLab:runAction( CCSequence:create( arr ) )
end

--[[
	rIdx 行
	cIdx 列
]]
-- 上下左右
function PlayLayer:checkOverCells( starType, rIdx, cIdx )
	-- left
	self:checkThisCell( starType, rIdx-1, cIdx )

	-- up
	self:checkThisCell( starType, rIdx, cIdx+1 )

	-- right
	self:checkThisCell( starType, rIdx+1, cIdx )

	-- buttom
	self:checkThisCell( starType, rIdx, cIdx-1 )

end

-- 检查这个cell
function PlayLayer:checkThisCell( starType, rIdx, cIdx )
	local cell = nil
	if self.data.cells[rIdx] then
		cell = self.data.cells[rIdx][cIdx]
	end
	if cell then
		if cell:getStarType() == starType and not cell:getIsOver() then
			cell:setIsOver( true )
			table.insert( self.data.overCells, cell )
			table.insert( self.data.needCheckCells, cell )
		end
	end
end

function PlayLayer:initUILayer()
	self:addChild( self.view.uiLayer )

	self:initTipsInfo()
	self:initMenu()
end

function PlayLayer:initTipsInfo()
	self.view.goalScoreLab = CCLabelTTF:create( "目标  1000", "", 30 )
	self.view.goalScoreLab:setPosition( ccp( VisibleRect:top().x, VisibleRect:top().y - 50 ) )
	self.view.uiLayer:addChild( self.view.goalScoreLab )

	self.view.curScoreLab = CCLabelTTF:create( "1000", "", 30 )
	self.view.curScoreLab:setPosition( ccp( VisibleRect:top().x, VisibleRect:top().y - 100 ) )
	self.view.uiLayer:addChild( self.view.curScoreLab )
end

function PlayLayer:initMenu()
	self.view.mainMenu = CCMenu:create()
	self.view.uiLayer:addChild( self.view.mainMenu )
	self.view.mainMenu:setPosition( CCPointZero )

	local backItem = CCMenuItemFont:create( "back" )
	backItem:registerScriptTapHandler( 
		function()
			--print( "back" )
			LayerUtil.replaceLayer( HelloMenuLayer:new() )
		end 
	)
	backItem:setAnchorPoint( ccp( 0, 1 ) )
	backItem:setPosition( ccp( VisibleRect:left().x + 20, VisibleRect:top().y - 20 ) )
	self.view.mainMenu:addChild( backItem )
end



--endregion
