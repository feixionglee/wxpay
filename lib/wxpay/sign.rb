module Wxpay
  module Sign
    extend self

    # used in wechat pay api
    def sign_package params
      params_str = create_sign_str params

      if params_str =~ /trade_type=APP/
        key = Wxpay.app_api_key
      else
        key = Wxpay.api_key
      end
      Digest::MD5.hexdigest(params_str+"&key=#{key}").upcase
    end

    # used in wechat jssdk ,
    def sign_jssdk params
      params_str = create_sign_str params

      Digest::SHA1.hexdigest params_str
    end

    # used in wechat pay notify
    def verify params
      sign = params.delete('sign')
      params['sign'] == sign_package(params)
    end

    private

    def create_sign_str options={}, sort=true
      unsigned_str = ''
      if sort
        unsigned_params = options.sort
      end
      unsigned_params.each do |key,value|
        unsigned_str += (key.to_s + '=' + value.to_s + '&')
      end
      unsigned_str = unsigned_str[0, unsigned_str.length - 1]
    end

  end
end