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

function TestApiV3:Test_resolve_url()

   local newApiV3=protocol:new({access_token=1234324,requests_session='123', rate_limiter='aaa' })

   local url=newApiV3:_resolve_url('/akshay/12',true)

   print("Resolved url" .. url)

   luaunit.assertStrContains(url,'/akshay/12')

end


function TestApiV3:Test_authorization_url()
   local client_id='18243'
   
   local redirect_uri='http://localhost:5000/auth'
   local newApiV3=protocol:new({access_token=1234324,requests_session='123', rate_limiter='aaa' })
   local auth_url=newApiV3:authorization_url(client_id,redirect_uri,'auto',{ 'view','write'})
   luaunit.assertStrContains(auth_url,'https')
   print(auth_url)

end



os.exit(luaunit.LuaUnit.run())

