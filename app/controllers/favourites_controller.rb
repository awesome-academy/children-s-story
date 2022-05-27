class FavouritesController < ApplicationController
  before_action :find_favourite, only: [:create, :destroy]

  def create
    current_user.favourite(@tale)
    respond_to do |format|
      format.html { redirect_to @tale }
      format.js
    end
  end

  def destroy
    current_user.unfavourite(@tale)
    respond_to do |format|
      format.html { redirect_to @tale }
      format.js
    end
  end

  private

  def find_favourite
    @tale = Tale.find_by(id: params[:favourited_id])
  end
end
