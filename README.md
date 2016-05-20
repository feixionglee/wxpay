# Wxpay

A simple unofficial wechat pay gem, Support 'NATIVE', 'JSAPI', 'APP' payment mode.

## Installation

```ruby
gem 'wxpay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wxpay

## Configuration

These 4 configurations are for NATIVE and JSAPI pay
```ruby
Wxpay.app_id = 'YOUR_APP_ID',
Wxpay.app_secret = 'YOUR_APP_SECRET'
Wxpay.merchant_id = 'YOUR_MERCHANT_ID'
Wxpay.api_key = 'YOUR_API_KEY'
```
These 4 configurations are for APP pay
```ruby
Wxpay.app_app_id = 'YOUR_APP_APP_ID'
Wxpay.app_app_secret = 'YOUR_APP_APP_SECRET'
Wxpay.app_merchant_id = 'YOUR_APP_MERCHANT_ID'
Wxpay.app_api_key = 'YOUR_APP_API_KEY'
```

If want use debug mode, set this to true
```ruby
Wxpay.debug = true

# then you can print debug info to your stderr log

Wxpay.debug_info request.body.inspect
```

## Usage

Support there is a action named 'wxpay'

1, NATIVE pay
```ruby
  def wxpay
    @order = Order.find params[:id]
    @wxorder = Wxpay::Order.new body: @order.subject,
                                total_fee: @order.total_fee,
                                spbill_create_ip: request_ip,
                                notify_url: your_notify_url,
                                out_trade_no: @order.wxpay_trade_no,
                                trade_type: 'NATIVE',
                                product_id: @order.product_id   # 'product_id' is need for NATIVE pay
    resp = @wxorder.pay!

    if resp[:status] == "success"
      @code_url = resp[:code_url] # qrcode from wechat, you need to create qrcode image with this value
      render json: {state: 'success', code_url: @code_url}
    else
      @error_message = resp[:err_msg]
      render json: {state: 'failure', message: @error_message}
    end
  end
```

2, JSAPI pay
```ruby
  TODO
```

3, APP pay
```ruby
  TODO
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/feixionglee/wxpay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


