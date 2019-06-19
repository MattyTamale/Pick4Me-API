class CommentsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  def index
    render json: Comment.all
  end

  def show
    render json: Comment.find(params["id"])
  end

  def create
    render json: Comment.create(params["comment"])
  end

  def delete
    render json: Comment.delete(params["id"])
  end

  def update
    render json: Comment.update(params["id"], params["comment"])
  end

end
