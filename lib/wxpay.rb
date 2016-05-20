require "wxpay/version"

require "wxpay/sign"
require "wxpay/api"
require "wxpay/order"

module Wxpay
  mattr_accessor :app_id, :app_secret, :merchant_id, :api_key, # public payment and scanning payment
                :app_app_id, :app_merchant_id, :debug # app payment

  def self.debug?
    !!debug
  end

  def self.debug_info message
    if self.debug?
      warn '++++WXPAY--DEBUG--INFO++++'
      warn message
      warn '--------------------------'
    end
  end
end
