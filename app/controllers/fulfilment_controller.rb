class FulfilmentController < ApplicationController
	def fulfil_order
		if params[:order_id].present?
			service = FulfilmentService.new({
      		order_id: params[:order_id],
      		shop_url: params[:shop_url]}).set_fulfilment
		end
	end
end
