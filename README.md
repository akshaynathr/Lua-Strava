# Documentation

luastrava is a Lua library for Strava API version 3.

## Getting started
luastrava is in early stage of its development.So rock file for the library is not yet available.To test the library the folder luastrava can  be downloaded to your project folder from github repository.

## Importing the library

``` 
    local strava_client = require('luastrava.client').Client
```

## Authentication and Authorization with Strava API

To retrieve data about athletes and activities from Strava API, you will need authorization to do so.Refer [Strava official documentation](https://strava.github.io/api/) for the detailed descriptiona about OAuth2 protocol used by Strava for authentication.

### Requesting Authorization



