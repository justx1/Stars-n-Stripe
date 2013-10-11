require 'sinatra'
require 'stripe'
require 'haml'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  haml :index
end

post '/charge' do
#  begin

    customer = Stripe::Customer.create(
      :email => 'customer@example.com',
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :amount      => 1000, # in cents (isn't the amount passed into the POST body???)
      :description => 'Charge from XYZ Checkout',
      :currency    => 'usd',
      :customer    => customer
    )

#  rescue Stripe::CardError => e
  # Card has been declined

  haml :charge

#  end
end

__END__

@@ layout
%html
  %head
    %title **/** Stars'n'Stripe **/**
  %body
    =yield

@@index
%h1 */* Stars'n'Stripe */*
%section.container
  .content
    %p Embedded checkout
    %img{ :src => "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRaxhiip4BTdDkEh5JgZ-mOJ-hscEnYm7uE27Ml4BNAoCBH_bnH" }
  %p LOLcat, $20.00
  .button
    %form{ :action => "/charge", :method => "post" }
      %script{ :src => "https://checkout.stripe.com/v2/checkout.js", :class => "stripe-button", 
               :data => { :key => settings.publishable_key, :amount => "2000", :name => "Stars'n'Stripe */*", :description => "2 widgets ($20.00)", :image => "/unclesam.png" } }

%section.container
  .content
    %p XYZ checkout
    %img{ :src => "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRaxhiip4BTdDkEh5JgZ-mOJ-hscEnYm7uE27Ml4BNAoCBH_bnH" }
  %p LOLcat, $20.00
  .button
    %form{ :action => "/charge", :method => "post" }
    %article
      %label{ :class => "amount" }
      %span Amount: $5.00
    %script{ :src => "https://checkout.stripe.com/v2/checkout.js",
             :class => "stripe-button", :data => { :key => settings.publishable_key } }

%section.container
  %script{ :src => "https://checkout.stripe.com/v2/" } Stripe.setPublishableKey(settings.publishable_key);
  .content
    %p Stripe Custom Form Checkout
    %img{ :src => "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRaxhiip4BTdDkEh5JgZ-mOJ-hscEnYm7uE27Ml4BNAoCBH_bnH" }
  %p LOLcat, donation-based
  .form
    %form{ :action => "", :method => "post", :id => "payment-form" }
      %span{ :class => "payment-errors"}
    %div{ :class => "form-row" }
      %label
        %span Card Number
        %input{ :type => "text", :size => "20", :data => { :stripe => "number" } }
    %div{ :class => "form-row" }
      %label
        %span Expiration (MM/YYYY)
        %input{ :type => "text", :size => "2", :data => { :stripe => "exp-month" } }
      %span /
      %input{ :type => "text", :size => "4", :data => { :stripe => "exp-year" } }
    %button{ :type => "submit"} Submit Payment

@@charge
%h2 Thanks, you paid <strong>$5.00</strong>!