class CommentsController < ApplicationController
	before_action :require_user
	before_action :set_comment, only: [:vote]
	before_action :require_same, only: [:vote]

	def create
		@post = Post.find_by(slug: params[:post_id])
		@comment = Comment.new(params.require(:comment).permit(:body))
		@comment.post = @post
		@comment.creator = current_user

		if @comment.save
			flash[:notice] = "Your comment was added."
			redirect_to post_path(@post)
		else
			render 'posts/show'
		end
	end

	def vote
		Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
	    flash[:notice] = "Your vote was counted"
	    redirect_to post_path(params[:post_id])
	end
	
	def set_comment
      @comment = Comment.find(params[:id])
  	end  

  	def require_same 
	    @vote = Vote.all
	    @vote.each do |vote|
	      if vote.creator == current_user && vote.voteable_id == @comment.id && vote.voteable_type == 'Comment'
	        flash[:error] = "You already have voted"
	        redirect_to post_path(params[:post_id]) and return
	      end
	    end
  	end

end
