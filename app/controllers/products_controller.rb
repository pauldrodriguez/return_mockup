class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :edit, :update, :destroy]
  def new
    @product = Product.new
  end

  def create
  end

  def update

     respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end

  end

  def edit
    @product =  Product.find(params[:id])
  end

  def destroy
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name,:sku)
    end
end
