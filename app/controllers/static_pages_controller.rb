class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def help
  end

  def about
  end
end
