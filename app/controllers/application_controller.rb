class ApplicationController < ActionController::Base
  protect_from_forgery

  def home
    # Simulate some load. On my system it makes the page render in about 100ms
    1.upto(1_000_000) { |n| n**2 }
    render text: "OK"
  end
end
