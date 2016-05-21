require "wxpay/version"

require "wxpay/sign"
require "wxpay/api"
require "wxpay/order"

module Wxpay
  class << self
    attr_accessor :app_id, :app_secret, :merchant_id, :api_key, # JSAPI and NATIVE
                  :app_app_id, :app_app_secret, :app_merchant_id, :app_api_key, # APP
                  :debug

    def debug?
      !!debug
    end

    def debug_info message
      if self.debug?
        warn '++++WXPAY--DEBUG--INFO++++'
        warn message
        warn '--------------------------'
      end
    end
  end
end
