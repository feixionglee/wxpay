require 'builder'
require 'faraday'

module Wxpay
  module Api
    module Unifiedorder
      def unifiedorder order, options={}
        random_str = SecureRandom.hex(10)

        defaults = {
          appid:            order.app_id,
          mch_id:           order.merchant_id,
          nonce_str:        random_str
        }

        param = defaults.merge(order.attributes).merge(options)

        sign = Wxpay::Sign.sign_package param

        _xm = Builder::XmlMarkup.new
        request_str = _xm.xml {
          param.each do |k, v|
            _xm.tag! k.to_s, v
          end
          # _xm.appid             WEIXIN_ID
          # _xm.body              param[:body]
          # _xm.mch_id            MERCHAT_ID
          # _xm.nonce_str         param[:nonce_str]
          # _xm.notify_url        param[:notify_url]
          # _xm.openid            param[:openid]
          # _xm.out_trade_no      param[:out_trade_no]
          # _xm.product_id        param[:product_id]
          # _xm.spbill_create_ip  param[:spbill_create_ip]
          # _xm.total_fee         param[:total_fee]
          # _xm.trade_type        param[:trade_type]
          _xm.sign              sign
        }

        Faraday.post 'https://api.mch.weixin.qq.com/pay/unifiedorder', request_str
      end
    end
  end
end