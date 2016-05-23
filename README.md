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

1, NATIVE pay

Example code:

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

**Notice**

Compare to NATIVE pay, you need more settings to make jsapi works.
you need to set a url of the web page which the JSAPI pay launch,
and you need set permission to get base user info, e.g. **openid**, from wechat server.

Example code:
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
      @prepay_id = resp[:prepay_id]
      signature_params
    else
      @error_message = resp[:err_msg]
    end
  end
```
**wxpay_openid** is convenient for you to get current_user's openid, you can call method directly within your action, or you can put it into before_action.
**signature_params** is another method to set params for wechat javascript api for payment
```ruby
  protected

  def signature_params
    @timestamp = Time.current.to_i
    @nonce_str = SecureRandom.hex(16)
    @package = "prepay_id=#{@prepay_id}"

    param = {
      'appId' => Wxpay.app_id,
      'timeStamp' => @timestamp,
      'nonceStr' => @nonce_str,
      'package' => @package,
      'signType' => 'MD5'
    }

    @pay_sign = Wxpay::Sign.sign_package param

    # success_url is a url the wechat will redirect when the payment succeed
    @success_url = YOUR_SUCCESS_URL
  end
```


in your view:
```ruby
= render_jsapi_script(timestamp: @timestamp, nonce_str: @nonce_str, package: @package, pay_sign: @pay_sign, success_url: @success_url)
```
this helper method will generate some javascript into the view, and launch the wechat jsapi payment

3, APP pay

Example code:
```ruby
def wxpay_app
  @order = Order.find params[:id]
  Wxpay::Order.new body: @order.subject,
                  total_fee: @order.total_fee,
                  spbill_create_ip: request_ip,
                  notify_url: your_notify_url,
                  out_trade_no: @order.wxpay_trade_no,
                  trade_type: 'APP',
                  openid: session[:wxpay_openid]

  resp = @wxorder.pay!

  if resp[:status] == "success"
    @prepay_id = resp[:prepay_id]
  else
    @error_message = resp[:err_msg]
  end

  @timestamp = Time.current.to_i
  @nonce_str = SecureRandom.hex(16)
  @package = "Sign=WXPay"

  param = {
    'appid' => Wxpay.app_app_id,
    'partnerid' => Wxpay.app_merchant_id,
    'trade_type' => 'APP',
    'prepayid' => @prepay_id,
    'package' => @package,
    'noncestr' => @nonce_str,
    'timestamp' => @timestamp
  }

  @pay_sign = WxSign.sign_package param
  # return the hash to your app
  return json: { appid: APP_APP_ID,
                 partner_id: APP_MERCHANT_ID,
                 prepay_id: @prepay_id,
                 package_value: @package,
                 nonce_str: @nonce_str.to_s,
                 time_stamp: @timestamp,
                 sign: @pay_sign
                }
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/feixionglee/wxpay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


