
--*-lua-*--
package = "luastrava"
version = "0.1.1-1"
source = {
  url = "git://github.com/akshaynathr/Lua-Strava",
  tag = "v0.1.1",
}
description = {
  summary = "A Lua REST library for strava api",
  detailed = [[
            
  ]],
  homepage = "https://akshaynathr.github.io/Lua-Strava/",
  license = "MIT"
}
dependencies = {
  "lua = 5.1",
  
}
build = {
  type="builtin",
  modules={
    ["luastrava.client"] = "Lua-Strava/luastrava/client.lua",
    ["luastrava.protocol"] = "Lua-Strava/luastrava/protocol.lua",
    ["luastrava.encode"] = "Lua-Strava/luastrava/encode.lua",
  }
}

