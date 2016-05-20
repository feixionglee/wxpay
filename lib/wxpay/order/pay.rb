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

        if xml.at('code_url').present?
          code_url = xml.at('code_url').text
          return {status: 'success', code_url: code_url}
        else
          return {status: 'error', err_msg: xml.at('err_code_des').text}
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
          return {status: 'error', err_msg: xml.at('err_code_des').text}
        else
          return {status: 'error', err_msg: xml.at('return_msg').text}
        end
      end

      # App支付
      def app_pay
        resp = Wxpay::Api.unifiedorder self
        xml = Nokogiri::XML resp.body

        Wxpay.debug_info resp.body

        if xml.at('code_url').present?
          code_url = xml.at('code_url').text
          return {status: 'success', code_url: code_url}
        else
          return {status: 'error', err_msg: xml.at('return_msg').text}
        end
      end
    end
  end
end