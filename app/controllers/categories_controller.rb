class CategoriesController < ApplicationController
  def index
  	@category = Category.all
  end

  def show
  	@category = Category.find(params[:id])
  end	

  def new
  	@category = Category.new
  end

  def create
  	@category = Category.new(params.require(:category).permit!)

  	if @category.save
  		flash[:notice] = "You created a new category!"
  		redirect_to categories_path
  	else
  		#validations
  		render :new
  	end

  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(params[:category].permit(:name))
      redirect_to @category
    else
      render 'edit'
    end 
  end      

end
