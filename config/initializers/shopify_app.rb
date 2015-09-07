ShopifyApp.configure do |config|
  config.api_key = ENV['SHOPIFY_CLIENT_API_KEY']
  config.secret = ENV['SHOPIFY_CLIENT_API_SECRET']
  config.redirect_uri = "<redirect_uri>"
  config.scope = "read_orders, read_products"
  config.embedded_app = true
end
