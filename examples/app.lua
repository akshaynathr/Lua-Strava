local lapis = require("lapis")
local config=require("lapis.config").get()
local strava=require("luastrava.client").Client
local app = lapis.Application()
app:enable("etlua")
local client_id='18243'
local client_secret='99675b7ee65da2654be5c831cb09342079f5fdd9'

local client=strava:new()




function table.val_to_str ( v )
      if "string" == type( v ) then
      	v = string.gsub( v, "\n", "\\n" )
        if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
        	return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
      else
        return "table" == type( v ) and table.tostring( v ) or
                                                    tostring( v )
      end
                                                  end


      function table.key_to_str ( k )
            if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
                    return k
                      else
                              return "[" .. table.val_to_str( k ) .. "]"
                                end
                            end

                            function table.tostring( tbl )
                                 local result, done = {}, {}
                                   for k, v in ipairs( tbl ) do
                                           table.insert( result, table.val_to_str( v ) )
                                               done[ k ] = true
                                                 end
                                                   for k, v in pairs( tbl ) do
                                                           if not done[ k ] then
                                                                table.insert( result,
                                                                  table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
                                                                      end
                                                                        end
                                                                          return "{" .. table.concat( result, "," ) .. "}"
                                                                      end




app:match("index","/", function()
    --return "Hello"
  return {render=true}
end)


app:get("/login",function()
     local url=client:authorization_url{client_id=client_id,redirect_uri='http://ec2-54-254-233-219.ap-southeast-1.compute.amazonaws.com:8080/auth',scope='write'}
     -- print(url)
   return {redirect_to=url}
end)


app:get("/auth",function(self)
     
 local code=self.params.code --Fetch the code sent via url parameter
          
client:exchange_code_for_token(client_id,client_secret,code) --fetch token

self.session.token=client:get_access_token() -- token is saved in session 

if (self.session.token) then return {redirect_to='/map'}
else return {redirect_to='/error'} end
 end)



 app:get("/main",function(self) 
--    local year=2015
    client:set_access_token(self.session.token)
    local races=client:get_races({})
    --return  table.tostring(races)
     return { json = races }
    end)

app:get("/test.json", function(self)
  return { json = { status = "ok" } }
end)


app:match("map","/map", function()
    return {render=true}
end)
return app

