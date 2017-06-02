luaunit=require('luaunit')
protocol=require('protocol').ApiV3


TestApiV3={}

function TestApiV3:Test_New()

   local newApiV3=protocol:new({access_token=1234324,requests_session='123', rate_limiter='aaa' })

   luaunit.assertTable(newApiV3)

   return newApiV3


end

function TestApiV3:Test_request()


end

function TestApiV3:Test_authorization_url()
   local client_id='18243'
   
   local redirect_uri='http://localhost:5000/auth'
   local newApiV3=protocol:new({access_token='123',requests_session='123', rate_limiter='aaa' })
   local auth_url=newApiV3:authorization_url(client_id,redirect_uri,'auto')
   luaunit.assertStrContains(auth_url,'https')
   print(auth_url)
   local client_secret='99675b7ee65da2654be5c831cb09342079f5fdd9'
   local code='b65727861a137e2b4a223d61dd6c0793c474bcd7'
   local token=newApiV3:exchange_code_for_token(client_id,client_secret,code)
   luaunit.assertStrContains(token,'e39b7ad9cf84ca4d8e6c8adb438f3a682ef2ae8b')

   print("TOKEN= " .. token)
   


end



os.exit(luaunit.LuaUnit.run())

