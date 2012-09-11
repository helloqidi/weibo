module WeiboOAuth2
  class Client < OAuth2::Client

	def direct_messages
      @direct_messages ||= WeiboOAuth2::Api::V2::DirectMessages.new(@access_token) if @access_token
    end


  end
end

module WeiboOAuth2
  module Api
    module V2
      class DirectMessages< Base

		def messages(opt={})
          hashie get("direct_messages.json", :params => opt)
        end

	  end
	end
  end
end
