module Util
  class JsonWebToken
    class << self
      def encode(user, user_agent)
        # TODO: use the user id and
        # the user agent to generate
        # a token with the JWT gem
        #
        # EXAMPLE
        # {
        #   user_id: user.id,
        #   user_agent: user_agent
        # }
        payload = {
          user_id: user.id,
          user_agent: user_agent,
          exp: 90.days.from_now.to_i
        }
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
      end

      def decode(token)
        # TODO: decode the token using the
        # JWT gem and return it with
        # symbolized keys
        body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        HashWithIndifferentAccess.new body
        rescue 
          #  or nil if it is invalid
          # and raises
          nil
      end
    end
  end
end
