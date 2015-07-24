--region luaMain.lua
--Author : czh
--Date   : 2015/7/14
-- lua入口文件

function __G__TRACKBACK__( msg )
	print( "----------------------------------------" )
	print( string.format( "LUA ERROR: %s\n", msg ) )
	print( debug.traceback() )
	print( "----------------------------------------" )
end

local function main()
	print( "0000000000 -- main start -- 0000000000" )

	collectgarbage( "setpause", 100 )
	collectgarbage( "setstepmul", 5000 )

	require( "script/RequireFiles" )
	require( "script/views/HelloMenu" )

	LayerUtil.runLayer( HelloMenuLayer:new( 1, 2 ) )
end

xpcall( main, __G__TRACKBACK__ )


--endregion
