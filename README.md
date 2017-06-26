# Documentation

**luastrava** is a Lua library for Strava API version 3.

## Getting started
luastrava is in early stage of its development.So rock file for the library is not yet available.To test the library the folder luastrava can  be downloaded to your project folder from github repository.

## Importing the library

``` 
    local strava_client = require('luastrava.client').Client
```

## Authentication and Authorization with Strava API

To retrieve data about athletes and activities from Strava API, you will need authorization to do so.Refer [Strava official documentation](https://strava.github.io/api/) for the detailed description about OAuth2 protocol used by Strava for authentication.

### Requesting Authorization

The __luastrava.client.Client__ class provides __luastrava.client.Client:authorization_url()__ method to generate authorization URL. This link opens the login page of strava which can be used by the user to grant permissions and access to the user's account data.

```
local strava=require('luastrava.client').Client
local client=strava:new()
local url=client:authorization_url{client_id=CLIENT_ID, redirect_uri='http://strava_app.example.com/authorization'}

```

For development , localhost or 127.0.0.1 can be used  as redirect host.

```
local url=client:authorization_url{client_id=CLIENT_ID, redirect_uri='http://127.0.0.1:5000/authorization'}

```

Example from lapis based web app is given below
```
 app:get("/", function(self) 
  --create authorization url  
  local url=client:authorization_url{client_id=client_id,redirect_uri='http:// localhost:8080/auth',scope='write'} 

  --redirect to the url 
      return {redirect_to=url} 
  end) 
  
```


The link can be used to gain permission rights from the user.In the URL handler */authorization* specified as redirect_uri, a temporary code is sent back from strava server. This temporary code needs to be exchanged for user's token from Strava

```

 app:get("/auth",function(self)
  
   local code=self.params.code --Fetch the code sent via url parameter
            
   client:exchange_code_for_token(client_id,client_secret,code) --fetch token

  self.session.token=client:get_access_token() -- token is saved in session 

   return "Authorized token=".. client:get_access_token() --Display the token  as a proof for authorization. 
                            
end)

```
The resulting **access_token** must be saved for later use. In the above web app the token  is saved in session.The token is valid till the access is revoked by user.

Using the token the data from Strava API can be retrieved.

```
local strava=require('luastrava.client').Client
local client=strava:new()
client:set_access_token(TOKEN_STORED)
local athlete=client:get_athlete()


```

##Athletes
Every user in strava is called as athlete. The following functions helps to retrieve athlete data from Strava.Strava API documentation can be found [here] (https://strava.github.io/api/v3/athlete)

###Retrive current athlete
Details about current user can be retrieved using **luastrava.client.Client:get_athlete()** function.No parameters is required.

```
    local athlete=client:get_athlete()
    print(athlete.firstname)
```
function returns a table containing all fields in the json response.

### Retrieve another athlete
The same function **luastrava.client.Client:get_athlete()** can be used to retrieve details of another athlete by passing athlete id as parameter.  
```
    local athlete=client:get_athlete(831114)
    print(athlete.firstname)

```
### List athlete friends
The function **luastrava.client.Client:get_athlete_friends()** can be used to retrieve the friends of current user or a specific user. To retrieve friends of a specific user call the function with athlete id.

``` 
    local friends=client:get_athlete_friends()

    local deepaks_friend=client:get_athlete_friends(834123)
```






