local Log = {}
Log.__index = Log

function Log.debug(tag, message)
end

function Log.error(tag, message)
end

function Log.info(tag, message)
    print(tag .. ': ' .. message)
end

return Log
