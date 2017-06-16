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
    local result
    if not args.athlete_id then
        result=self.protocol:get('/athlete/followers')
    else
        result=self.protocol:get('/athletes/' .. args.athlete_id ..'/followers')
    end
    return result
end


function Client:get_both_following(args)
    if not args.athlete_id then error("No athlete id provided") end

    local result=self.protocol:get('/athletes/' .. athlete_id .. '/both-following')

    return result
end

function Client:get_athlete_stats(athlete_id)
    if not athlete_id then
        athlete_id=self:get_athlete().id
    end
    if athlete_id==nil then error("no athlete id") end
    local result=self.protocol:get('/athletes/' .. athlete_id .. '/stats')
    return result
end

function Client:get_athlete_koms(args) --(athlete_id)
    
    local result=self.protocol:get('/athletes/' .. args.athlete_id .. '/koms')
    return result
end

function Client:get_athlete_zones(args)
    
    local result=self.protocol:get('/athlete/zones')
    return result
end


function Client:get_activity(args) --args(athlete_id,include_all_efforts)
    args.include_all_efforts=args.include_all_efforts or false
    local res=self.protocol:get('/activities/' .. args.athlete_id,{include_all_efforts=include_all_efforts})

    return res
end


function Client:get_friend_activities(args) --args(limit)
    local res=self.protocol:get('/activities/following' )

    return res
end


function Client:create_activity(args) --args(name,activity_type,start_date_local,elapsed_time,description,distance)
    
    local params={name=args.name,type=args.activity_type, start_date_local=args.start_date_local,elapsed_time=args.elapsed_time}
    if args.description then  params.description=args.description end

    if args.distance then params.distance=args.distance end

    local raw_activity=self.protocol:post{url='/activities',params=params }

    return raw_activity
end


return { Client=Client}
