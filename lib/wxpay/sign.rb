module Wxpay
  module Sign
    extend self

    def sign_package params_str, options={}
      if params_str =~ /trade_type=APP/ || options[:trade_type] == 'APP'
        key = Wxpay.app_api_key
      else
        key = Wxpay.api_key
      end
      Rails.logger.info "sign_package:::::: #{params_str}"
      Digest::MD5.hexdigest(params_str+"&key=#{key}").upcase
    end

    def sign_pay params_str
      Rails.logger.info "sign_pay:::::: #{params_str}"
      Digest::SHA1.hexdigest params_str
    end

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

    def verify params
      sign_str = create_sign_str(params.except('sign'))
      params['sign'] == sign_package(sign_str)
    end
  end
end