require 'test_helper'

class WxpayTest < Minitest::Test
  def test_config
    assert_equal false, Wxpay.debug?
  end

  def test_config_debug
    Wxpay.debug = true

    assert_equal true, Wxpay.debug?
  end
end