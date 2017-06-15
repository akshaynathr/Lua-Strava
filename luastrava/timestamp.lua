
function time.TimeStamp(dateStringArg)
       
local inYear, inMonth, inDay, inHour, inMinute, inSecond, inZone = string.match(dateStringArg, '^(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)(.-)$')

local zHours, zMinutes = string.match(inZone, '^(.-):(%d%d)$')
                  
local returnTime = os.time({year=inYear, month=inMonth, day=inDay, hour=inHour, min=inMinute, sec=inSecond, isdst=false})
                  
  if zHours then   returnTime = returnTime - ((tonumber(zHours)*3600) + (tonumber(zMinutes)*60))
end
return returnTime
end



return time




