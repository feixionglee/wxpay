require 'test_helper'

class WxpayController < ActionController::Metal
  include Wxpay::Controllers
end

class Wxpay::ControllersTest < Minitest::Test

  def test_wxpay_openid
    request.session["wxpay_openid"] = '123qwe'
    assert true
  end

  def test_wxpay_notify_verify
    assert false
  end

  def test_wxpay_notify_response_xml
    assert false
  end
end