class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end
end
