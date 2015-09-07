ShopifyApp.configure do |config|
  config.api_key = "<api_key>"
  config.secret = "<secret>"
  config.redirect_uri = "<redirect_uri>"
  config.scope = "read_orders, read_products"
  config.embedded_app = true
end
