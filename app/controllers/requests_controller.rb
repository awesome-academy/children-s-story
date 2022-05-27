class RequestsController < ApplicationController
  before_action :find_request, only: [:show, :update_status, :destroy]

  def index
    @requests = Request.all
  end

  def new
    @request = Request.new
  end

  def show; end

  def show_seen
    @seens = Request.seen.paginate(page: params[:page])
  end

  def show_not_seen
    @notseens = Request.notseen.paginate(page: params[:page])
  end

  def create
    @request = Request.new(request_params)
    @request.user_id = current_user.id
    @request.status = 'notseen'

    if @request.save
      flash[:success] = 'Cảm ơn bạn đã đóng góp ý kiến'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update_status
    @request.seen!
    redirect_to request_path
  end

  def destroy
    @request.destroy
    flash[:success] = 'Hủy ý kiến thành công'
    redirect_to @request
  end

  private

  def find_request
    @request = Request.find_by(id: params[:id])
    redirect_to root_path unless @request
  end

  def request_params
    params.require(:request).permit(:content, :title)
  end
end
