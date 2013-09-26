require 'sinatra'
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

post '/charge' do
  @amount = 500
  
  customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge',
    :currency    => 'usd',
    :customer    => customer
  )

  erb :charge
end

__END__

@@ layout
  <!DOCTYPE html>
  <html>
  <head></head>
  <body>
    <%= yield %>
  </body>
  </html>

@@index
  <form action="/charge" method="post">
    <article>
      <label class="amount">
        <span>Amount: $5.00</span>
      </label>
    </article>

    <script src="https://checkout.stripe.com/v2/checkout.js" class="stripe-button" data-key="<%= settings.publishable_key %>"></script>
  </form>

@@charge
  <h2>Thanks, you paid <strong>$5.00</strong>!</h2>