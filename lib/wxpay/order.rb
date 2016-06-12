require 'wxpay/order/pay'

module Wxpay
  class Order
    include Pay

    class OrderIllegal < RuntimeError
    end

    ### 详见微信支付文档
    AVAILABLE_ATTRIBUTES = [
      :body, # 商品描述
      :total_fee, # 订单总金额，单位为分
      :out_trade_no, # 商户订单号
      :trade_type, # 交易类型
      :spbill_create_ip, # 终端IP, APP和网页支付提交用户端ip，Native支付填调用微信支付API的机器IP。
      :notify_url, # 通知地址
      ###### 以下非必选参数
      :openid, # 用户标识, trade_type=JSAPI, 此参数必传，用户在商户appid下的唯一标识。
      :product_id, # 商品ID, trade_type=NATIVE, 此参数必传。
      :fee_type, # 货币类型, 默认人民币(CNY)
      :detail, # 商品详情
      :device_info, # 设备号
      :limit_pay, # 指定支付方式, e.g. no_credit--指定不能使用信用卡支付
      :time_start, # 交易起始时间, 格式为yyyyMMddHHmmss
      :time_expire, # 订单失效时间, 格式为yyyyMMddHHmmss
      :goods_tag, # 商品标记，代金券或立减优惠功能的参数
      :attach # 附加数据
    ]


    attr_accessor :attributes

    # attr_reader *AVAILABLE_ATTRIBUTES

    def initialize options={}
      @attributes = options.select {|key, value| AVAILABLE_ATTRIBUTES.include?(key)}

      puts @attributes.inspect

      @attributes.each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      unless @body &&
            @total_fee &&
            @out_trade_no &&
            @trade_type &&
            @spbill_create_ip &&
            @notify_url

        raise OrderIllegal, "missing params: #{options}"
      end

      unless ['NATIVE', 'APP', 'JSAPI'].include?(@trade_type)
        raise OrderIllegal, "trade_type must be one of ['NATIVE', 'APP', 'JSAPI']"
      end

      if @trade_type == 'NATIVE' && !@product_id
        raise OrderIllegal, "product_id is needed"
      end
    end

    # App支付有单独的 app_id 和 merchant_id
    def app_id
      self.trade_type == 'APP' ? Wxpay.app_app_id : Wxpay.app_id
    end

    def merchant_id
      self.trade_type == 'APP' ? Wxpay.app_merchant_id : Wxpay.merchant_id
    end
  end
end