class NeedsController < ApplicationController
  before_action :set_need, only: [:show, :edit, :update, :destroy]

  # GET /needs
  # GET /needs.json
  def index
    @needs = Need.all
  end

  # GET /needs/1
  # GET /needs/1.json
  def show
    @needs = Need.where.not(status: nil)
  end

  # GET /needs/new
  def new
    @need = Need.new
  end

  # GET /needs/1/edit
  def edit
  end

  def resolve
    @needs = Need.where(:group_id => params[:id])
    @needs.each do |need|
      need.status = "Resolved"
      need.update(status: "Resolved")
    end
    redirect_to controller: 'groups', action: 'show', id: params[:id], notice: 'The needs were successfully resolved'
  end
  # POST /needs
  # POST /needs.json
  def create
    group_id = need_params[:group_id]
    user_id = need_params[:user_id]
    item_id = Item.find_by_name(need_params[:item_id]).id
    target_need = Need.where(["user_id = ? and group_id = ? and item_id = ? and status = ?", user_id, group_id, item_id, "Unresolved"])
    if not(target_need.empty?)
      sum = target_need.sum(:quantity).to_s.to_d + need_params[:quantity].to_s.to_d
      target_need.update(:quantity => sum)
      redirect_to controller: 'groups', action: 'show', id: group_id
    else
      @need = Need.new(need_params)
      @need.item_id = item_id
      @need.status = "Unresolved"

      respond_to do |format|
        if @need.save
          format.html { redirect_to controller: 'groups', action: 'show', id: group_id, notice: 'Need was successfully created.' }
          format.json { render :show, status: :created, location: @need }
        else
          format.html { render :new }
          format.json { render json: @need.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /needs/1
  # PATCH/PUT /needs/1.json
  def update
    respond_to do |format|
      if @need.update(need_params)
        format.html { redirect_to @need, notice: 'Need was successfully updated.' }
        format.json { render :show, status: :ok, location: @need }
      else
        format.html { render :edit }
        format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /needs/1
  # DELETE /needs/1.json
  def destroy
    temp = params[:group_id]
    @need.destroy
    respond_to do |format|
      format.html { redirect_to controller: 'groups', action: 'show', id: temp , notice: 'Need was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_need
      @need = Need.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def need_params
      params.require(:need).permit(:group_id, :user_id, :item_id, :quantity)
    end
end
