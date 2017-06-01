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

   local newApiV3=protocol:new({access_token=1234324,requests_session='123', rate_limiter='aaa' })
   local auth_url=newApiV3:authorization_url('121231','http://localhost:8080','auto',{'write'},'state')
   luaunit.assertStrContains(auth_url,'https')
   print(auth_url)

end



os.exit(luaunit.LuaUnit.run())

