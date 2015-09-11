require 'shopify_app'

class FulfilmentService

	def initialize(params)
		@order_id = params[:order_id]
		@shop_url = params[:shop_url]
	end

	def set_fulfilment
		begin
			# Creating a new shopify session to set fulfillment status
			tmp_shop = Shop.where(shopify_domain: @shop_url).first
			session = ShopifyAPI::Session.new(@shop_url, tmp_shop.shopify_token)
			ShopifyAPI::Base.activate_session(session)

			f = ShopifyAPI::Fulfillment.new
			f.tracking_number = "12345"
			# f.tracking_url = ... etc.
			f.notify_customer = "true"
			f.prefix_options = { :order_id => @order_id }
			tmp_order = ShopifyAPI::Order.find(@order_id).fulfillments
			tmp_order = f
			tmp_order.save
		rescue Exception => error
			puts error.backtrace
		end
	end
end