require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class HubSpot < OmniAuth::Strategies::OAuth2

      # option :client_options, {
      #   :site           => 'http://localhost:3000',
      #   :authorize_url  => 'http://localhost:3008/oauth/authorize',
      #   :token_url      => 'http://localhost:3008/oauth/token'
      # }

      option :client_options, {
        :site           => 'https://api.hubspot.com',
        :authorize_url  => 'https://app.hubspot.com/oauth/authorize',
        :token_url      => 'https://api.hubapi.com/oauth/v1/token'
      }

      option :name, 'hubspot'

      option :authorize_options, [:scope]

      uid { raw_info['id'] }
      
      info do
        pp raw_info

        # "token": "CJSP5qf1KhICAQEYs-gDIIGOBii1hQIyGQAf3xBKmlwHjX7OIpuIFEavB2-qYAGQsF4",
        #     "user": "test@hubspot.com",
        #     "hub_domain": "demo.hubapi.com",
        #     "scopes": [
        #     "contacts",
        #     "automation",
        #     "oauth"
        # ],
        #     "hub_id": 62515,
        #     "app_id": 456,
        #     "expires_in": 21588,
        #     "user_id": 123,
        #     "token_type": "access"

        prune!({
          'id'              => raw_info['hub_id'],
          'app_id'          => raw_info['app_id'],
          'user_id'         => raw_info['user_id'],
          'token_type'      => raw_info['token_type'],
        })
      end
      
      extra do 
        { 'user' =>  prune!(raw_info) }
      end
      
      def raw_info
        pp access_token
        @raw_info ||= access_token.get("/oauth/v1/access-tokens/#{access_token.token}").parsed
      end

      private

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

    end
  end
end

OmniAuth.config.add_camelization 'hubspot', 'HubSpot'
