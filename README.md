# OmniAuth for HubSpot

HubSpot OAuth2 Strategy for OmniAuth 1.0.

Supports the OAuth 2.0 server-side. Read the HubSpot docs for more details: 

http://developers.hubspot.com/docs/methods/oauth2/oauth2-overview

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-hubspot'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::HubSpot` is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :hubspot, ENV['HUBSPOT_CLIENT_ID'], ENV['HUBSPOT_SECRET']
end
```

## Configuring

You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: A space-separated list of scopes you want to request from the user. See the HubSpot docs for a full list of available permissions.

For example, to request `content` permission:
 
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :hubspot, ENV['HUBSPOT_CLIENT_ID'], ENV['HUBSPOT_SECRET'], :scope => 'content'
end
```

## Authentication Hash

Here's an example *Authentication Hash* available in `request.env['omniauth.auth']`:

```ruby
{"provider"=>"hubspot",
 "uid"=>nil,
 "info"=>
  {"uid"=>33333,
   "hub_id"=>1111,
   "app_id"=>2222,
   "token_type"=>"access",
   "scopes"=>["content", "oauth", "files"],
   "email"=>"michael@domain.com",
   "hub_domain"=>"domain.com"},
 "credentials"=>
  {"token"=>
    "dfkjadlfkjasdkjflaskdjfjsldflasjdflkasdjflaskdjf",
   "refresh_token"=>"lkfkjasldjkflaskjdflkasjdlfjkasdljfk",
   "expires_at"=>1489053154,
   "expires"=>true},
 "extra"=>
  {"user"=>
    {
     "user"=>"michael@domain.com",
     "hub_domain"=>"domain.com",
     "scopes"=>["content", "oauth", "files"],
     "hub_id"=>1111,
     "app_id"=>2222,
     "user_id"=>33333,
     "token_type"=>"access"}}}
```

The precise information available may depend on the permissions which you request.
