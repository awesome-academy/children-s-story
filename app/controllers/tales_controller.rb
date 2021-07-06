class TalesController < ApplicationController
  before_action :find_tale, only: [:show, :preview, :edit, :update, :followers, :favouriters, :update_status, :destroy]
  before_action :admin_user,only: [:edit, :update, :destroy]

  def index
    @tales = Tale.search(params[:term])
  end

  def show_archived
    @tales = Tale.archived.paginate(page: params[:page])
    @show_archiveds = Tale.archived.paginate(page: params[:page])
  end

  def newest
    @newests = Tale.active.paginate(page: params[:page]).order_by_id
  end

  def many_follow
    @many_followers = Tale.active.paginate(page: params[:page]).sort_by_follow
  end

  def many_favourite
    @many_favourites = Tale.active.paginate(page: params[:page]).sort_by_favourite
  end

  def preview
    if @tale.reviewtales.blank?
      @average_reviewtale = 0
    else
      @average_reviewtale = @tale.reviewtales.average(:rating).round(2)
    end
  end

  def show
    @tale.update_attribute :view, @tale.view.to_i + 1
  end
  
  def new
    @tale = Tale.new
  end

  def create
    @tale = Tale.new(tale_params)
    @tale.image.attach(params[:tale][:image])
    @tale.status = current_user.admin? ? "active" : "archived"

    if @tale.save
      redirect_to @tale
    else
      render "new"
    end
  end

  def edit

  end

  def update_status
    if @tale.active!
      flash[:success] = "Thêm truyện thành công"
    else
      flash[:danger] = "Thêm truyện không thành công" 
    end 
    redirect_to show_archived_tales_path
  end

  def update
    if @tale.update(tale_params)
      redirect_to tale_path(@tale)
    else
      flash[:success] = "cập nhật không thành công"
      render "edit"
    end
  end

  def destroy
    @tale.destroy
    redirect_to tales_url
  end

  def followers
    @title = "Followers"
    @tale = Tale.find_by(id: params[:id])
    @tales = @tale.followers.paginate(page: params[:page])
    render "show_follow"
  end

  def favouriters
    @title = "Favouriters"
    @tale = Tale.find_by(id: params[:id])
    @tales = @tale.favouriters.paginate(page: params[:page])
    render "show_favourite"
  end

  private
    def tale_params
      params.require(:tale).permit(:title, :description, :author, :category_id, :image, :author_id,
        tale_contents_attributes: [:id, :image, :audio, :text, :content_type, :_destroy])
    end

    def find_tale
      @tales = Tale.all
      @tale = Tale.find_by(id:params[:id])
      unless @tale
        redirect_to root_path
      end
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
