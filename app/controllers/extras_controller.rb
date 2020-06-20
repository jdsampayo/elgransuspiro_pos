# == Schema Information
#
# Table name: extras
#
#  id         :uuid             not null, primary key
#  nombre     :text
#  precio     :decimal(, )      default(0.0)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class ExtrasController < ApplicationController
  load_and_authorize_resource

  before_action :set_extra, only: [:show, :edit, :update, :destroy]

  # GET /extras
  # GET /extras.json
  def index
    @extras = Extra.kept
  end

  # GET /extras/1
  # GET /extras/1.json
  def show
  end

  # GET /extras/new
  def new
    @extra = Extra.new
  end

  # GET /extras/1/edit
  def edit
  end

  # POST /extras
  # POST /extras.json
  def create
    @extra = Extra.new(extra_params)

    respond_to do |format|
      if @extra.save
        format.html { redirect_to @extra, notice: 'Extra was successfully created.' }
        format.json { render :show, status: :created, location: @extra }
      else
        format.html { render :new }
        format.json { render json: @extra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /extras/1
  # PATCH/PUT /extras/1.json
  def update
    respond_to do |format|
      if @extra.update(extra_params)
        format.html { redirect_to @extra, notice: 'Extra was successfully updated.' }
        format.json { render :show, status: :ok, location: @extra }
      else
        format.html { render :edit }
        format.json { render json: @extra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /extras/1
  # DELETE /extras/1.json
  def destroy
    @extra.discard
    respond_to do |format|
      format.html { redirect_to extras_url, notice: 'Extra was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extra
      @extra = Extra.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def extra_params
      params.require(:extra).permit(:nombre, :precio)
    end
end
