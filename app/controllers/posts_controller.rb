class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, only: [:new, :create, :edit, :update, :vote]
  before_action :require_creator, only: [:edit, :update]
  before_action :require_same, only: [:vote]

  def index
  	@post = Post.all
  end

  def show
      @comment = Comment.new
  end	

  def new
  	@post = Post.new
  end

  def create
  	@post = Post.new(post_params)
    @post.creator = current_user
    

  	if @post.save
  		flash[:notice] = "You created a new post!"
  		redirect_to posts_path
  	else
  		#validations
  		render :new
  	end

  end

  def edit
  end

  def update
    
    if @post.update(post_params)
      flash[:notice] =  "You updated the post!"
      redirect_to post_path(@post)
    else
      render :edit
    end 
  end   

  def vote
    Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html do
        flash[:notice] = "your vote was counted"
        redirect_to posts_path
      end 

      format.js
      #commit

    end
  end

  private
  def post_params 
    params.require(:post).permit(:url, :title, :description)
  end

  def set_post
      @post = Post.find(params[:id])
  end  

  def require_creator 
    access_denied unless @post.creator == current_user
  end

  def require_same 
    @vote = Vote.all
    @vote.each do |vote|
      if vote.creator == current_user && vote.voteable_id == @post.id
        flash[:error] = "You already have voted"
        redirect_to root_path and return
      end
    end
  end
  

end
