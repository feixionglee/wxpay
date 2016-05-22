module Wxpay
  module Helpers
    def render_jsapi_script options={}
      javascript_tag <<-SCRIPT
<script>
function onBridgeReady(){
  WeixinJSBridge.invoke(
    'getBrandWCPayRequest', {
      "appId"    : #{Wxpay.app_id},
      "timeStamp": #{options[:timestamp]},
      "nonceStr" : #{options[:nonce_str]},
      "package"  : #{options[:package]},
      "signType" : "MD5",
      "paySign"  : #{options[:pay_sign]}
    },
    function(res){
      if(res.err_msg == "get_brand_wcpay_request:ok" ) {
        window.location = "#{options[:success_url]}";
      }
    }
  );
}
if (typeof WeixinJSBridge == "undefined"){
  if( document.addEventListener ){
    document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
  }else if (document.attachEvent){
    document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
    document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
  }
}else{
  onBridgeReady();
}
</script>
SCRIPT
    end
  end
end