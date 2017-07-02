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

## Athletes
Every user in strava is called as athlete. The following functions helps to retrieve athlete data from Strava.Strava API documentation can be found [here] (https://strava.github.io/api/v3/athlete)

### Retrive current athlete
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

    local deepaks_friend=client:get_athlete_friends{athlete_id=834123}
```

function returns table consisting of all fields in json response.Please refer Strava API documentation for more details.


### List athlete followers
The function **luastrava.client.Client:get_athlete_followers** retrieves the followers of the user. It works similar to get_athlete_friends function.
```
    local followers=client:get_athlete_followers()

    local deepaks_followers=client:get_athlete_followers{athlete_id=834123}
```

### List both following
Retrieve the athletes who both the authenticated user and the indicated athlete are following.The function **luastrava.client.Client:get_both_following** is used for this.

```
    local both_following=client:get_both_following{athlete_id=987653}

```
function returns a lua table containing all fields of json response from Strava.

### Update current athlete
This requires **write** permission, requested during authorization process.To update details of current user, **luastrava.client.Client:update_athlete** function is used.Functions takes the table as arguments with following parameters.

- city
- state
- country
- sex
- weight *(integer)*

```
     local update_res=client:update_athlete{city='Kannur',state="Kerala",country="India",weight=60}
    
```
## Activities
Activities are the base object for Strava runs, rides, swims etc.

### Retrieve an activity
Returns a detailed representation if the activity is owned by the requesting athlete. Returns a summary representation for all other requests.Function **luastrava.client.Client:get_activity** is used to retrieve the activity data.** athlete_id** is required as parameter. Parameter are passed as table containing following fields.

- athlete_id
- include_all_efforts *(optional)*


```
     local result=client:get_activity{athlete_id=860001}

```

### Create an activity
**luastrava.client.Client:create_activity** helps to create manually entered activity.This requires **write** permission, requested during authorization process.Parameters are passed as lua table with following fields.

- name
- activity_type
- start_date_local
- elapsed_time
- description
- distance

```
local result=client:create_activity{name='test',activity_type='snowboard',  start_date_local='2015-07-06T12:08:27',elapsed_time=1000}
```

### Update activity
**luastrava.client.Client:update_activity** updates the activity.This requires **write** permissions,as requested during the authorization process.
Takes lua table as parameter with following fields.

- name: **string** optional
- activity_type: **string** optional
- private: **boolean** optional defaults to false
- commute: **boolean** optional defaults to false
- trainer: **boolean** optional defaults to false
- gear_id: **string** optional 'none' clears gear from activity
- description: **string** optional


