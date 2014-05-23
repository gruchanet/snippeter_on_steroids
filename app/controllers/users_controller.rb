class UsersController < ApplicationController
  def index
    if !params[:page].nil? && !params[:page].blank? && params[:page].to_i < 1
      redirect_to(users_path)
      return false
    end

    if params[:page].nil? || params[:page].blank?
      params[:page] = 1
    end

    @users = User.paginate(page: params[:page], per_page: 10).order('created_at DESC')

    respond_to do |format|
      format.html
      format.js
    end
  end
end

