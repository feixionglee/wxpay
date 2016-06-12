require 'test_helper'

# class WxpayController < ActionController::Metal
#   include Wxpay::Controllers

#   before_action :wxpay_openid, only: :wxpay_jsapi

#   def wxpay_jsapi
#   end
# end

class Wxpay::ControllersTest < Minitest::Test

  # def test_wxpay_openid
  #   request.session["wxpay_openid"] = '123qwe'
  #   get :wxpay_jsapi
  #   assert true
  # end

  def test_wxpay_notify_verify
    flunk "TODO"
  end

  def test_wxpay_notify_response_xml
    flunk "TODO"
  end
end