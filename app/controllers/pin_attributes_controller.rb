class PinAttributesController < ApplicationController
  before_action :set_pin_attribute, only: [:show, :edit, :update, :destroy]

  # GET /pin_attributes
  # GET /pin_attributes.json
  def index
    @pin_attributes = PinAttribute.all
  end

  # GET /pin_attributes/1
  # GET /pin_attributes/1.json
  def show
  end

  # GET /pin_attributes/new
  def new
    @pin_attribute = PinAttribute.new
  end

  # GET /pin_attributes/1/edit
  def edit
  end

  # POST /pin_attributes
  # POST /pin_attributes.json
  def create
    @pin_attribute = PinAttribute.new(pin_attribute_params)

    respond_to do |format|
      if @pin_attribute.save
        format.html { redirect_to @pin_attribute, notice: 'Pin attribute was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pin_attribute }
      else
        format.html { render action: 'new' }
        format.json { render json: @pin_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pin_attributes/1
  # PATCH/PUT /pin_attributes/1.json
  def update
    respond_to do |format|
      if @pin_attribute.update(pin_attribute_params)
        format.html { redirect_to @pin_attribute, notice: 'Pin attribute was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pin_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pin_attributes/1
  # DELETE /pin_attributes/1.json
  def destroy
    @pin_attribute.destroy
    respond_to do |format|
      format.html { redirect_to pin_attributes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin_attribute
      @pin_attribute = PinAttribute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pin_attribute_params
      params.require(:pin_attribute).permit(:name)
    end
end
