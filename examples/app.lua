local lapis = require("lapis")
local config=require("lapis.config").get()
local client=require("luastrava.client").Client
local app = lapis.Application()
app:enable("etlua")

app:match("index","/", function()
    --return "Hello"
  return {render=true}
end)

return app
