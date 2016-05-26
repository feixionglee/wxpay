require 'test_helper'

class Wxpay::SignTest < Minitest::Test
  def test_sign_package
    assert_equal '4ECDFB4DC6B76403CBB6F19F0C66ABAF', Wxpay::Sign.sign_package({a: 1})
  end

  def test_sign_jssdk
    assert_equal '4ECDFB4DC6B76403CBB6F19F0C66ABAF', Wxpay::Sign.sign_package({a: 1})
  end

  def test_verify
    assert_equal false, Wxpay::Sign.verify({'a' => 1, 'sign' => 'xxx'})
  end
end