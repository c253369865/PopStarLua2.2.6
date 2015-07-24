--region CommonFun.lua
--Author : czh
--Date   : 2015/7/14
-- 公用方法

FunUtil = {}

--		nil 表示找不到
function FunUtil.getSuperMethod(table, methodName)
    local mt = getmetatable(table)
    local method = nil
    while mt and not method do
        method = mt[methodName]
        if not method then
            local index = mt.__index
            if index and type(index) == "function" then
                method = index(mt, methodName)
            elseif index and type(index) == "table" then
                method = index[methodName]
            end
        end
        mt = getmetatable(mt)
    end
    return method
end



--endregion
