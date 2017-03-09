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
        :site           => 'https://api.hubapi.com',
        :authorize_url  => 'https://app.hubspot.com/oauth/authorize',
        :token_url      => 'https://api.hubapi.com/oauth/v1/token'
      }

      option :name, 'hubspot'

      option :authorize_options, [:scope]

      uid { raw_info['id'] }
      
      info do
        prune!({
          'uid'             => raw_info['user_id'],
          'hub_id'          => raw_info['hub_id'],
          'app_id'          => raw_info['app_id'],
          'token_type'      => raw_info['token_type'],
          'scopes'          => raw_info['scopes'],
          'email'           => raw_info['user'],
          'hub_domain'      => raw_info['hub_domain'],
        })
      end
      
      extra do 
        { 'user' =>  prune!(raw_info) }
      end
      
      def raw_info
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
