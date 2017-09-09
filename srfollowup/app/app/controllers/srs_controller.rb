class SrsController < ApplicationController
  before_action :set_sr, only: [:show, :edit, :update, :destroy]

  # GET /srs
  # GET /srs.json
  def index
    @srs = Sr.all
  end

  # GET /srs/1
  # GET /srs/1.json
  def show
  end

  # GET /srs/new
  def new
    @sr = Sr.new
  end

  # GET /srs/1/edit
  def edit
  end

  # POST /srs
  # POST /srs.json
  def create
    @sr = Sr.new(sr_params)

    respond_to do |format|
      if @sr.save
        format.html { redirect_to @sr, notice: 'Sr was successfully created.' }
        format.json { render :show, status: :created, location: @sr }
      else
        format.html { render :new }
        format.json { render json: @sr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /srs/1
  # PATCH/PUT /srs/1.json
  def update
    respond_to do |format|
      if @sr.update(sr_params)
        format.html { redirect_to @sr, notice: 'Sr was successfully updated.' }
        format.json { render :show, status: :ok, location: @sr }
      else
        format.html { render :edit }
        format.json { render json: @sr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /srs/1
  # DELETE /srs/1.json
  def destroy
    @sr.destroy
    respond_to do |format|
      format.html { redirect_to srs_url, notice: 'Sr was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sr
      @sr = Sr.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sr_params
      params.require(:sr).permit(:userid, :datetime, :winloss, :newsr, :performance, :srvariation, :hero, :comment)
    end
end
