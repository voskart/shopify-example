class BillingController < ApplicationController
  around_filter :shopify_session
  layout 'embedded_app'

  def index
    tmp_shop = Shop.where(shopify_domain: params[:shop_url]).first
    shop_sess = ShopifyAPI::Session.new(params[:shop_url], tmp_shop.shopify_token)
    ShopifyAPI::Base.activate_session(shop_sess)
    session[:session_shopify] = shop_sess;
    charge = ShopifyAPI::RecurringApplicationCharge.create(
      name: 'Shipcon Basic Plan',
      price: 1,
      return_url: billing_confirm_url,
      trial_days: 3,
      test: Rails.env.development? || ENV['SHOPIFY_TEST']
      )
    redirect_to charge.confirmation_url
  end

  def confirm
  	begin
  		ShopifyAPI::RecurringApplicationCharge.find(params[:charge_id]).activate
  		redirect_to root_path
  	rescue => error
  		redirect_to "https://apps.shopify.com/#{ENV['SHOPIFY_APP']}"
  	end
  end
end
