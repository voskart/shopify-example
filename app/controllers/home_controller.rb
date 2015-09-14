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
    # First we need to check if the shop already exists in our db
    if (Shop.where(shopify_domain: @shop_session.url).present?)
  	  # Check if there is a charge present
  	  if (ShopifyAPI::RecurringApplicationCharge.current)
        # Check the status, if pending AND the user is coming from the app-store
        if (ShopifyAPI::RecurringApplicationCharge.current.status = 'pending' && URI(request.referer).host == "apps.shopify.com")
          redirect_to billing_index_path(:shop_url => @shop_session.url)
        # If the status is pending AND the user comes from the app-store
        elsif (ShopifyAPI::RecurringApplicationCharge.current.status = 'pending' && URI(request.referer).host == @shop_session.url)
          redirect_to billing_error_path
        # If the status is active, render the page
        elsif (ShopifyAPI::RecurringApplicationCharge.current.status = 'active')          
          @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
          @orders = ShopifyAPI::Order.find(:all, :params => {:limit => 10})
        end
      # If there is no charge, bill him
      else
        # If the user is coming from his apps-page
        if (URI(request.referer).host ==  @shop_session.url)
          redirect_to billing_error_path
        # If he is coming from the app store, show the charge prompt 
        else
          redirect_to billing_index_path(:shop_url => @shop_session.url)
        end
      end
    else
  	  # If the user is coming from his apps-page (host matches the domain)
  		if (URI(request.referer).host ==  @shop_session.url)
  		  # Redirect him to an error-page
        redirect_to billing_error_path
      else
      	# Otherwise he got here from the store
        redirect_to billing_index_path(:shop_url => @shop_session.url)
        end
      end
    end
  end
