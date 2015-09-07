# shopify-example
## Why does this repository exist?
I encountered many difficulties implementing my first shopify embedded app. Features I wanted to implement were either not documented well enough or not documented at all. I want to ease implementing similar features for other programmers.
## Implemented features
I am using the shopify-app gem provided by Shopify, the authentication process is handled by the gem. The app is an embedded application which supports useful features like Order Fulfilment or Recurring Application Charges just to name a few.
## How to use the app
* clone this repository: git clone https://github.com/ginetrix/shopify-example.git
* bundle install
* rake db:migrate (rake db:setup)
* **Important:** this application uses *dotenv*, to set your variables simply create a .env.development file in your app-root
* thin start --ssl
