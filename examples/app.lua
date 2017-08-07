local lapis = require("lapis")
local config=require("lapis.config").get()
local client=require("luastrava.client").Client
local app = lapis.Application()
app:enable("etlua")
local client_id='18243'
local client_secret='99675b7ee65da2654be5c831cb09342079f5fdd9'


app:match("index","/", function()
    --return "Hello"
  return {render=true}
end)


app:get("login",function()
     local url=client:authorization_url{client_id=client_id,redirect_uri='http://  localhost:8080/auth',scope='write'}
      print(url)
   return {redirect_to=url}
end)



app:get("/auth",function(self)
     
 local code=self.params.code --Fetch the code sent via url parameter
          
client:exchange_code_for_token(client_id,client_secret,code) --fetch token

self.session.token=client:get_access_token() -- token is saved in session 

if (self.session.token) then return {redirect_to='/main'}
else return {redirect_to='/error'} end

                         
 end)

return app
