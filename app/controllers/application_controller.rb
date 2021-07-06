class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :load_categories, :load_authors

  def load_categories
    @categories = Category.all
  end

  def load_authors
    @authors = Author.all
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
end
