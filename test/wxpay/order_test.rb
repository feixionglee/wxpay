require 'test_helper'

class Wxpay::OrderTest < Minitest::Test
  def test_initialize
    assert_raises Wxpay::Order::OrderIllegal do
      @order = Wxpay::Order.new({
        body: 'test',
        total_fee: 100,
        out_trade_no: '12345',
        trade_type: 'NATIVE',
        spbill_create_ip: '127.0.0.1'
      })
    end
  end

  def test_initialize_native
    assert_raises Wxpay::Order::OrderIllegal do
      @order = Wxpay::Order.new({
        body: 'test',
        total_fee: 100,
        out_trade_no: '12345',
        trade_type: 'NATIVE',
        spbill_create_ip: '127.0.0.1',
        notify_url: 'notify_url'
      })
    end
  end

  def test_initialize_jsapi
    assert_raises Wxpay::Order::OrderIllegal do
      @order = Wxpay::Order.new({
        body: 'test',
        total_fee: 100,
        out_trade_no: '12345',
        trade_type: 'JSAPIX',
        spbill_create_ip: '127.0.0.1',
        notify_url: 'notify_url'
      })
    end
  end

  def test_jsapi_pay
    flunk "TODO"
  end

  def test_native_pay
    flunk "TODO"
  end

  def test_app_pay
    flunk "TODO"
  end
end