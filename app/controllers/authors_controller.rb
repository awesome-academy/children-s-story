class AuthorsController < ApplicationController
  before_action :find_author, only: [:show, :edit, :update, :destroy]
  
  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to @author
    else
      render "new"
    end
  end

  def index
    @authors = Author.all
  end

  def show
  end

  def edit
  end

  def update
    if @author.update(author_params)
      redirect_to author_path(@author)
    else
      render "edit"
    end  
  end

  def destroy
    @author.destroy
    redirect_to author_url
  end

  private

  def find_author
    @author = Author.find_by(id: params[:id])
    unless @author
      redirect_to root_path
    end
  end

  def author_params
    params.require(:author).permit(:name, :profile, :image)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
