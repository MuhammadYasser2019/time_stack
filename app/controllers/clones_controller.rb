class ClonesController < ApplicationController
  before_action :set_clone, only: [:show, :edit, :update, :destroy]

  # GET /clones
  # GET /clones.json
  def index
    @clones = Clone.all
  end

  # GET /clones/1
  # GET /clones/1.json
  def show
  end

  # GET /clones/new
  def new
    @clone = Clone.new
  end

  # GET /clones/1/edit
  def edit
  end

  # POST /clones
  # POST /clones.json
  def create
    @clone = Clone.new(clone_params)

    respond_to do |format|
      if @clone.save
        format.html { redirect_to @clone, notice: 'Clone was successfully created.' }
        format.json { render :show, status: :created, location: @clone }
      else
        format.html { render :new }
        format.json { render json: @clone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clones/1
  # PATCH/PUT /clones/1.json
  def update
    respond_to do |format|
      if @clone.update(clone_params)
        format.html { redirect_to @clone, notice: 'Clone was successfully updated.' }
        format.json { render :show, status: :ok, location: @clone }
      else
        format.html { render :edit }
        format.json { render json: @clone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clones/1
  # DELETE /clones/1.json
  def destroy
    @clone.destroy
    respond_to do |format|
      format.html { redirect_to clones_url, notice: 'Clone was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clone
      @clone = Clone.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clone_params
      params.fetch(:clone, {})
    end
end
