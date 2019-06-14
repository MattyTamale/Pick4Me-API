class FavoritesController < ApplicationController

  # skip_before_action :verify_authenticity_token

  def index
    render json: Favorite.all
  end

  def show
    render json: Favorite.find(params["id"])
  end

  def create
    render json: Favorite.create(params["favorite"])
  end

  def delete
    render json: Favorite.delete(params["id"])
  end

  def update
    render json: Favorite.update(params["id"], params["favorite"])
  end

end
