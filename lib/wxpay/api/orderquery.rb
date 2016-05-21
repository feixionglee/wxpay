require 'builder'
require 'faraday'

module Wxpay
  module Api
    module Orderquery
      def orderquery order, options={}
        random_str = SecureRandom.hex(10)
        param = {
          appid: order.appid,
          mch_id: order.merchant_id,
          nonce_str: random_str,
          out_trade_no: order.wxpay_trade_no
        }

        sign = Wxpay::Sign.sign_package param

        _xm = Builder::XmlMarkup.new
        request_str = _xm.xml {
          _xm.appid          Wxpay.app_id
          _xm.mch_id         Wxpay.merchant_id
          _xm.nonce_str      random_str
          _xm.out_trade_no   order.wxpay_trade_no
          _xm.sign           sign
        }

        Faraday.get 'https://api.mch.weixin.qq.com/pay/orderquery', request_str
      end
    end
  end
end