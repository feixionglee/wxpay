require 'test_helper'

class Wxpay::SignTest < Minitest::Test
  def setup
    out_trade_no = '78f66e89960bfdca4210448af55b7fb5'

    @package = {
      body: 'test',
      total_fee: 100,
      spbill_create_ip: '127.0.0.1',
      notify_url: 'wxpay_notify_users_orders_url',
      out_trade_no: out_trade_no,
      product_id: 1,
      time_start: '20160612124833',
      time_expire: '20160612125844'
    }
  end

  def test_sign_package
    assert_equal 'DD190637CA2182E330E884C1CF20DF43', Wxpay::Sign.sign_package(@package.merge(trade_type: 'NATIVE'))
  end

  def test_sign_jssdk
    assert_equal '689D51ECFE346732ADCB72D01CC7449A', Wxpay::Sign.sign_package(@package.merge(trade_type: 'JSAPI'))
  end
end