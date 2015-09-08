class HomeController < AuthenticatedController
=begin
	This is the only solution I came up with. I don't know if there is a possibility to make
	it cleaner. First of all I'm checking whether the current charge is valid, if not I am
	checking how the user got here. This can happen on two different ways. He could've either 
	clicked "Get" once again in the store listing or he could've clicked the app label in his
	apps page. This (imo very ugly) workaround is only needed because Shopify doesn't allow to display
	the Accept-Charges-Popup more than once (X-FRAME). It only appears when a user authenticates a second time 
	by clicking "Get". 
=end

  def index
  	# Check if the charge is active
  	if (ShopifyAPI::RecurringApplicationCharge.current)
    	@products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
    	@orders = ShopifyAPI::Order.find(:all, :params => {:limit => 10})
    else
    	# Retrieve the current shop-domain
		current_url = ShopifyAPI::Shop.current.myshopify_domain
		# If the user is coming from his apps-page (host matches the domain)
		if (URI(request.referer).host ==  current_url)
			# Redirect him to an error-page
        	redirect_to billing_error_path
        else
        	# Otherwise he got here from the store
        	redirect_to billing_index_path(:shop_url => current_url)
    	end
	end
  end
end
