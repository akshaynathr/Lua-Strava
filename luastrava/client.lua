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


function Client:authorization_url(args)--args( client_id,redirect_uri,approval_prompt,scope,state)
    args.approval_prompt=args.approval_prompt or 'auto'

    return self.protocol:authorization_url(args.client_id,args.redirect_uri,args.approval_prompt,args.scope,args.state)
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


function Client:update_athlete(args) --args(city,state,country,sex,weight
    local params={ city=args.city,
                   state=args.state,
                   country=args.country,
                   sex=args.sex}
    if args.weight then params.weight=tonumber(args.weight) end

    local athlete=self.protocol:put{url='/athlete',params=params}

    return athlete

end

function Client:get_athlete_friends(args) --args(athlete_id,limit)
    if not args.athlete_id then
        result=self.protocol:get('/athlete/friends')
    else 
        result=self.protocol:get('/athletes/'.. athlete_id ..'/friends')

    end
    return result
end

function Client:get_athlete_followers(args) -- args(athlete_id,limit)
    if not args.athlete_id then
        result=self.protocol:get('/athlete/followers')
    else
        result=self.protocol:get('/athletes/' .. args.athlete_id ..'/followers')
    end
    return result
end

function Client:get_athlete_stats(athlete_id)
    if not athlete_id then
        athlete_id=self:get_athlete().id
    end
    if athlete_id==nil then error("no athlete id") end
    result=self.protocol:get('/athletes/' .. athlete_id .. '/stats')
    return result
end

function Client:get_athlete_koms(args)
    
    local result=self.protocol:get('/athletes/' .. args.athlete_id .. '/koms')
    return result
end
return { Client=Client}
