require 'wxpay/api/unifiedorder'
require 'wxpay/api/orderquery'

module Wxpay
  module Api
    extend Unifiedorder
    extend Orderquery
  end
end