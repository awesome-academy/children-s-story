class ReviewtalesController < ApplicationController
  before_action :find_tale
  before_action :find_reviewtale, only: [:edit, :update, :destroy]

  def new
    @reviewtale = Reviewtale.new
  end

  def create
    @reviewtale = Reviewtale.new(reviewtale_params)
    @reviewtale.tale_id = @tale.id
    @reviewtale.user_id = current_user.id
    if @reviewtale.save
      redirect_to preview_tale_path(@tale)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @reviewtale.update(reviewtale_params)
      redirect_to preview_tale_path(@tale)
    else
      render 'edit'
    end
  end

  def destroy
    @reviewtale.destroy
    redirect_to preview_tale_path(@tale)
  end

  private

  def reviewtale_params
    params.require(:reviewtale).permit(:rating, :comment)
  end

  def find_tale
    @tale = Tale.find_by(id: params[:tale_id])
    redirect_to root_path unless @tale
  end

  def find_reviewtale
    @reviewtale = Reviewtale.find_by(id: params[:id])
    redirect_to root_path unless @reviewtale
  end
end
