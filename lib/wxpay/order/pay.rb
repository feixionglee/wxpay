require 'nokogiri'

module Wxpay
  class Order
    module Pay
      def pay!
        case self.trade_type
        when 'JSAPI'
          self.jsapi_pay
        when 'APP'
          self.app_pay
        when 'NATIVE'
          self.native_pay
        end
      end

    protected

      # 公众号支付
      def jsapi_pay
        resp = Wxpay::Api.unifiedorder self
        xml = Nokogiri::XML resp.body

        Wxpay.debug_info resp.body

        if xml.at('return_code').text == 'SUCCESS' && xml.at('result_code').text == 'SUCCESS'
          prepay_id = xml.at('prepay_id').text
          return jsapi_pay_process(prepay_id)
        elsif xml.at('return_code').text == 'SUCCESS'
          return {status: 'failure', err_msg: xml.at('err_code_des').text}
        else
          return {status: 'failure', err_msg: xml.at('return_msg').text}
        end
      end

      # 扫码支付
      def native_pay
        resp = Wxpay::Api.unifiedorder self
        xml = Nokogiri::XML resp.body

        Wxpay.debug_info resp.body

        if xml.at('return_code').text == 'SUCCESS' && xml.at('result_code').text == 'SUCCESS'
          return {status: 'success', code_url: xml.at('code_url').text}
        elsif xml.at('return_code').text == 'SUCCESS'
          return {status: 'failure', err_msg: xml.at('err_code_des').text}
        else
          return {status: 'failure', err_msg: xml.at('return_msg').text}
        end
      end

      # App支付
      def app_pay
        resp = Wxpay::Api.unifiedorder self
        xml = Nokogiri::XML resp.body

        Wxpay.debug_info resp.body

        if xml.at('return_code').text == 'SUCCESS' && xml.at('result_code').text == 'SUCCESS'
          prepay_id = xml.at('prepay_id').text
          return app_pay_process(prepay_id)
        elsif xml.at('return_code').text == 'SUCCESS'
          return {status: 'failure', err_msg: xml.at('err_code_des').text}
        else
          return {status: 'failure', err_msg: xml.at('return_msg').text}
        end
      end

    private

      def app_pay_process prepay_id
        timestamp = Time.current.to_i
        nonce_str = SecureRandom.hex(16)
        package = "Sign=WXPay"

        param = {
          'appid' => Wxpay.app_app_id,
          'partnerid' => Wxpay.app_merchant_id,
          'trade_type' => 'APP',
          'prepayid' => prepay_id,
          'package' => package,
          'noncestr' => nonce_str,
          'timestamp' => timestamp
        }

        pay_sign = WxSign.sign_package param
        # return the hash to your app
        return {
          status: 'success',
          result: {
            appid: Wxpay.app_app_id,
            partner_id: Wxpay.app_app_id,
            prepay_id: prepay_id,
            package_value: package,
            nonce_str: nonce_str.to_s,
            time_stamp: timestamp,
            sign: pay_sign
          }
        }
      end

      def jsapi_pay_process prepay_id
        timestamp = Time.current.to_i
        nonce_str = SecureRandom.hex(16)
        package = "prepay_id=#{prepay_id}"

        param = {
          'appId' => Wxpay.app_id,
          'timeStamp' => timestamp,
          'nonceStr' => nonce_str,
          'package' => package,
          'signType' => 'MD5'
        }

        pay_sign = Wxpay::Sign.sign_package param

        return {
          status: 'success',
          result: {
            app_id: Wxpay.app_id,
            timestamp: timestamp,
            nonce_str: nonce_str,
            package: package,
            pay_sign: pay_sign,
            sign_type: 'MD5'
          }
        }
      end

    end
  end
end