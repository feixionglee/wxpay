require 'minitest/autorun'
require 'wxpay'
require 'fakeweb'

Wxpay.app_id = '1' * 18
Wxpay.app_secret = '1' * 32
Wxpay.merchant_id = '1' * 10
Wxpay.api_key = '1' * 32