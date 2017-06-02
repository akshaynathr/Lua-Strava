local requests=require('requests')
local encode =require('encode')

local ApiV3 = { 
    server='www.strava.com',
    server_webhook_events='api.strava.com',
    api_base='/api/v3'
    }



function ApiV3:new (o) -- args (access_token,requests_session,rate_limiter)
    o= o or {}
    
    setmetatable(o,self)
    self.__index=self

    return o
end


function ApiV3:authorization_url(client_id,redirect_uri,approval_prompt,scope,state) 

    local a_prompt={ auto=true, force=true}


    assert(a_prompt[approval_prompt],"APPROVAL PROMPT MUST BE EITHER 'AUTO' OR 'FORCE'")

    params={
        client_id=client_id,
        redirect_uri=redirect_uri,
        approval_prompt=approval_prompt,
        response_type='code'

        }
    if type(scope)=='table' then 
        scope=table.concat(scope,',')
    end

    
       
    if scope~=nil then
        params.scope=scope
    end


    if state~=nil then 
        params.scope=state

    end

    return 'https://' .. self.server .. '/oauth/authorize?' .. encode.table(params)
end

function ApiV3:exchange_code_for_token(client_id,client_secret,code)
   response= self._request('https://'..  self.server ..'/oauth/token',{client_id=client_id,client_secret=client_secret,code=code},'POST')
   token=responese['access_token']
   self.access_token=token

   return token

end

function ApiV3:_resolve_url(url,use_webhook_server)
    server=use_webhook_server and self.server_webhook_events or self.server

    url='https://' .. server .. self.api_base .. url
    return url


end

function ApiV3:_request(url,params,method,files,check_for_errors,use_webhook_server)

    local http_methods={
        GET=requests.get,
        POST=requests.post,
        PUT=requests.put,
        DELETE=requests.delete
    
    }

    method=method or 'GET'
    check_for_errors= check_for_errors or true
    use_webhook_server=use_webhook_server or false

    url=self:_resolve_url(url,use_webhook_server)
    --log here
    
    if not params  then  params={} end

    if self.access_token then params.access_token=self.access_token
    end

    local requester=http_methods[method]
    assert(requester~=nil,'INVALID HTTP REQUEST')

    local raw=requester{url=url,params=params}
    if check_for_errors== true then
        self:_handle_protocol_error(raw)
    end
    local resp
    if raw.status_code == 204 then 
         resp={}
    else 
        resp=raw.json()
        
    end

    return resp
end

function ApiV3:_handle_protocol_error(raw)


end
return {
    ApiV3=ApiV3

}
