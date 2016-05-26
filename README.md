# Wxpay

A simple unofficial wechat pay gem, Support 'NATIVE', 'JSAPI', 'APP' payment mode. Only implement **unifiedorder** interface.

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

The most important part is the class Wxpay::Order and the instance method :pay!. You just need initialize a Wxpay::Order object, and call :pay!, check these examples for details.

1, NATIVE pay

In your controller
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

**Notice** Compare to NATIVE pay, you need more settings to make jsapi works. You need to set a url of the web page which the JSAPI pay launch, and you need set permission to get base user info, e.g. **openid**, from wechat server.

in your controller:
```ruby
  def wxpay_jsapi
    @order = Order.find params[:id]

    # if you do not get user's openid, JUST COMMENT THIS LINE
    # wxpay_openid

    @wxorder = Wxpay::Order.new body: @order.subject,
                                total_fee: @order.total_fee,
                                spbill_create_ip: request_ip,
                                notify_url: your_notify_url,
                                out_trade_no: @order.wxpay_trade_no,
                                trade_type: 'JSAPI',
                                openid: session[:wxpay_openid]

    resp = @wxorder.pay!

    if resp[:status] == "success"
      result = resp[:result]
      @app_id = result[:app_id]
      @timestamp = result[:timestamp]
      @nonce_str = result[:nonce_str]
      @package = result[:package]
      @pay_sign = result[:pay_sign]
      @success_url = YOUR_SUCCESS_URL # the url to redirect after user paid successful
    else
      @error_message = resp[:err_msg]
    end
  end
```
**wxpay_openid** is convenient for you to get current_user's openid, you can call method directly within your action, or you can put it into before_action.

in your view:
```ruby
= render_jsapi_script({
  app_id: @app_id,
  timestamp: @timestamp,
  nonce_str: @nonce_str,
  package: @package,
  pay_sign: @pay_sign,
  sign_type: "MD5",
  success_url: @success_url
  })
```
this helper method will generate some javascript into the view, and launch the wechat jsapi payment

3, APP pay

```ruby
def wxpay_app
  @order = Order.find params[:id]
  Wxpay::Order.new body: @order.subject,
                  total_fee: @order.total_fee,
                  spbill_create_ip: request_ip,
                  notify_url: YOUR_NOTIFY_URL,
                  out_trade_no: @order.wxpay_trade_no,
                  trade_type: 'APP',
                  openid: session[:wxpay_openid]

  resp = @wxorder.pay!

  if resp[:status] == "success"
    @result = resp[:result]
  else
    @error_message = resp[:err_msg]
  end

  return json: @result
end
```

4, Notify from Wechat Server
```ruby
  TODO
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/feixionglee/wxpay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


