class ApplicationController < ActionController::API
    before_action :verifyLogin
    private

    def auth_header
        request.headers['Authorization']
    end
    def verifyLogin
        if auth_header
            authentication = auth_header.split(' ')[1]
            begin
                @s = JWT.decode(authentication, Rails.application.secrets.secret_key_base, true, algorithm: 'HS512')
            rescue JWT::DecodeError
                render json: {status:"error", code:401, message:"Authentication Failed"}, status: :unauthorized
            end
        else
            render json: {status:"error", code:401, message:"Authentication Failed"}, status: :unauthorized
        end
    end
    def getUserId
        @s
    end
    def GenerateLoginToken user, rec_id
        JWT.encode(
                {userId:user, rec_id:rec_id}, 
                Rails.application.secrets.secret_key_base, 
                'HS512'
            )
    end
    def VerifyValidUserName userName
        if (!userName.match(/\A@?(\w){1,15}\Z/i) || userName.match(/twitter/i) || userName.match(/admin/i))
            false
        else
            true
        end
    end
end
