class LunchplanningController < ApplicationController
before_filter :login_required
  def index
    @user = current_user
    @restaurants = Restaurant.find(:all)
  end
end
