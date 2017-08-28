luaunit=require('luaunit')
protocol=require('luastrava.protocol').ApiV3
strava=require('luastrava.client').Client
client=strava:new()


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
   luaunit.assertStrContains(token,'2fcd3a7e5b83914df66ce05000a8a039f52519e5')

   print("TOKEN= " .. token)
   


end


function TestApiV3:Test_get_athlete()
    TOKEN='2fcd3a7e5b83914df66ce05000a8a039f52519e5'
    client:set_access_token(TOKEN)
    local athlete=client:get_athlete(8300114)
    luaunit.assertTable(athlete)
    local ath=client:get_athlete()
    luaunit.assertTable(ath)


end


function TestApiV3:Test_get_athlete_friend_Test()
    TOKEN='2fcd3a7e5b83914df66ce05000a8a039f52519e5'
    client:set_access_token(TOKEN)
    local res=client:get_athlete_friends({athlete_id=8300114})
    luaunit.assertTable(res)


end




 
 function TestApiV3:Test_get_athlete_followers_Test()
      TOKEN='2fcd3a7e5b83914df66ce05000a8a039f52519e5'
       client:set_access_token(TOKEN)
       local res=client:get_athlete_followers({athlete_id=8300114})
       luaunit.assertTable(res)
end


 
 function TestApiV3:Test_get_both_following()
          TOKEN='2fcd3a7e5b83914df66ce05000a8a039f52519e5'
           client:set_access_token(TOKEN)
           local res=client:get_both_following({athlete_id=8300114})
           --local res2=client:get_both_following({})
           luaunit.assertTable(res)
end


 
 function TestApiV3:Test_get_athlete_stat()
          TOKEN='2fcd3a7e5b83914df66ce05000a8a039f52519e5'
               client:set_access_token(TOKEN)
               local res=client:get_athlete_stats(8300114)
               luaunit.assertTable(res)
end


 
 function TestApiV3:Test_get_routes()
          TOKEN='2fcd3a7e5b83914df66ce05000a8a039f52519e5'
           client:set_access_token(TOKEN)
           local res=client:get_routes({athlete_id=8300114})
           return res
end



 
 function TestApiV3:Test_get_route()
          TOKEN='2fcd3a7e5b83914df66ce05000a8a039f52519e5'
           client:set_access_token(TOKEN)
            local res=client:get_route({athlete_id=8300114})
end


os.exit(luaunit.LuaUnit.run())

