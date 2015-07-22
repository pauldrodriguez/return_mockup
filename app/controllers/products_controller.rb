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
        session[:areas] = params[:areas]
        save_area_boxes(@product.id)
        if(params[:delete_area_ids]!="")
          ids_to_delete =params[:delete_area_ids].split("_")
          BoxArea.destroy(ids_to_delete)
        end
        format.html { render action: 'edit' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end

  end

  def edit
    #truncate_tables
    @product =  Product.find(params[:id])
    @pin_attributes = PinAttribute.where("parent_id=?",0)
    @box_areas = BoxArea.where("product_id=?",params[:id])
  end

  def destroy
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def truncate_tables
    tables = ['box_areas']
    #tables = ['orders']
    #ActiveRecord::Base.connection.execute("DELETE FROM orders where id>1")
    #ActiveRecord::Base.connection.execute("DELETE FROM order_items where id>=4")
    tables.each do |table|
      
      case ActiveRecord::Base.connection.adapter_name
            when 'MySQL'
              #self.connection.execute "ALTER TABLE #{self.table_name} AUTO_INCREMENT=#{options[:to]}"
            when 'PostgreSQL'
              ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY")
            when 'SQLite'
              ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
              ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
          else
          end
    
      
    end

  end
  private
    def save_area_boxes(product_id)
      areas = params[:areas]

      areas.each do |at_idx,items|
        items.each do |idx,item|
            if(item[:existing_id].to_i==0)
              box_area = BoxArea.new
              box_area.area_box_type = at_idx
              box_area.posx = item[:xpos]
              box_area.posy = item[:ypos]
              box_area.width = item[:width]
              box_area.height = item[:height]
              box_area.canvas_width = item[:canvas_width]
              box_area.canvas_height = item[:canvas_height]
              box_area.group_id = item[:pin_group]
              box_area.fill = item[:fill]
              box_area.product_id = product_id
              box_area.save
            else
              box_area = BoxArea.find(item[:existing_id])
              box_area.area_box_type = at_idx
              box_area.posx = item[:xpos]
              box_area.posy = item[:ypos]
              box_area.width = item[:width]
              box_area.height = item[:height]
              box_area.canvas_width = item[:canvas_width]
              box_area.canvas_height = item[:canvas_height]
              box_area.group_id = item[:pin_group]
              box_area.fill = item[:fill]
              box_area.product_id = product_id
              box_area.save
            end
          #box_are.pos
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name,:sku)
    end
end
