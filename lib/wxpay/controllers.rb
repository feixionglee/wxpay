module Wxpay
  module Controllers

    AUTHORIZE_URL = 'https://open.weixin.qq.com/connect/oauth2/authorize'
    ACCESS_TOKEN_URL = 'https://api.weixin.qq.com/sns/oauth2/access_token'

    def wxpay_openid
      return if session[:wxpay_openid]
      code = request.parameters[:code]
      # 如果code参数为空，则为认证第一步，重定向到微信认证
      if code.nil?
        url = URI.encode(request.url, /\W/)
        redirect_to "#{AUTHORIZE_URL}?appid=#{Wxpay.app_id}&redirect_uri=#{url}&response_type=code&scope=snsapi_base&state=WXPAY#wechat_redirect"
        return
      end

      #如果code参数不为空，则认证到第二步，通过code获取openid，并保存到session中
      begin
        url = "#{ACCESS_TOKEN_URL}?appid=#{Wxpay.app_id}&secret=#{Wxpay.app_secret}&code=#{code}&grant_type=authorization_code"
        openid = JSON.parse(URI.parse(url).read)["openid"]
        session[:wxpay_openid] = openid
        return openid
      rescue Exception => e
        warn "Wechat openid Exception::::::"
        warn e.message
      end
    end
  end
end