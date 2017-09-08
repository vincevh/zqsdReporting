class UsersController < ApplicationController
  def index
    @all_users = User.all
  end

  def create
    new_user = User.new
    new_user.username = params[:username] 
    new_user.battletag = params[:battletag] 
    new_user.save
    Sr.create({:newsr => params[:sr], :userid => new_user.id})
    redirect_to "/users"
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    User.find(params[:id]).update({:username => params[:username], :battletag => params[:battletag]}) 
    redirect_to "/users/#{params[:id]}"
  end
end
