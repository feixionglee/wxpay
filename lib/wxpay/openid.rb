module Wxpay
  module Openid
    AUTHORIZE_URL = 'https://open.weixin.qq.com/connect/oauth2/authorize'
    ACCESS_TOKEN_URL = 'https://api.weixin.qq.com/sns/oauth2/access_token'
    def get_openid
      code = params[:code]
      Rails.logger.info "code: #{code}"
      # 如果code参数为空，则为认证第一步，重定向到微信认证
      if code.nil?
        url = URI.encode(request.url.gsub('www.tangpin.me', 'tangpin.me'), /\W/)
        redirect_to "#{AUTHORIZE_URL}?appid=#{WEIXIN_ID}&redirect_uri=#{url}&response_type=code&scope=snsapi_base&state=tangpin#wechat_redirect"
        return
      end

      #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
      begin
        url = "#{ACCESS_TOKEN_URL}?appid=#{WEIXIN_ID}&secret=#{WEIXIN_SECRET}&code=#{code}&grant_type=authorization_code"
        session[:weixin_openid] = JSON.parse(URI.parse(url).read)["openid"]
      rescue Exception => e
        # ...
      end
    end
  end
end