local protocol=require('luastrava.protocol').ApiV3
--local date=require('date')

local Client={}

function Client:new(o)

    o= o or {rate_limit_requests=true}
    
    setmetatable(o,self)
    self.__index=self

    o.protocol=protocol:new{access_token=access_token,requests_session=requests_session,rate_limiter=rate_limiter}

    return o

end

--Getter function
function Client:get_access_token()
    return self.protocol.access_token
end

--Setter function
function Client:set_access_token(v)
    self.protocol.access_token=v
end


function Client:authorization_url(client_id,redirect_uri,approval_prompt,scope,state)
    approval_prompt=approval_prompt or 'auto'

    return self.protocol:authorization_url(client_id,redirect_uri,approval_prompt,scope,state)
end


function Client:exchange_code_for_token(client_id,client_secret,code)

    return self.protocol:exchange_code_for_token(client_id,client_secret,code)
end


function Client:get_athlete(athlete_id)
    local raw
    if  not athlete_id then
        raw=self.protocol:get('/athlete')
    else
        raw=self.protocol:get('/athletes/'.. athlete_id)
    end
    return raw

end


function Client:deauthorize()
     self.protocol:post{url="oauth/deauthorize"}
end

return { Client=Client}
