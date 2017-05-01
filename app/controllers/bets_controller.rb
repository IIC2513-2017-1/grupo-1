class BetsController < ApplicationController
  before_action :set_bet, only: [:show, :edit, :update, :destroy]

  # GET /bets
  # GET /bets.json
  def index
    @bets = Bet.all
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
  end

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # GET /bets/1/edit
  def edit; end

  def make_up_grand
    bets_id = params.select { |_, v| v == '1' }.map { |i| i[0] }
    @bets = []
    bets_id.each do |bet_id|
      @bets << Bet.find(bet_id)
    end
    if @bets.empty?
    @users = User.all
  end

  def create_grand
    grand = Grand.new(amount: params[:amount], user_id: params[:user_id])
    unless grand.save
      flash[:alert] = 'Grand no fue creado'
      redirect_to root_path
    end
    bets_id = params.select { |_, v| v == '-1' }.map { |i| i[0] }
    bets_id.each do |bet_id|
      p bet_id
      competitor_selection = Competitor.find(
        params["competitors#{bet_id}"]
      ).name
      MakeUp.create(grand_id: grand.id,
                    bet_id: bet_id,
                    selection: competitor_selection)
    end
    flash[:notice] = 'Grand fue creado con exito'
    redirect_to root_path
  end
  # POST /bets
  # POST /bets.json
  def create
    @bet = Bet.new(bet_params)

    respond_to do |format|
      if @bet.save
        format.html { redirect_to @bet, notice: 'Bet was successfully created.' }
        format.json { render :show, status: :created, location: @bet }
      else
        format.html { render :new }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bets/1
  # PATCH/PUT /bets/1.json
  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { render :show, status: :ok, location: @bet }
      else
        format.html { render :edit }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet.destroy
    respond_to do |format|
      format.html { redirect_to bets_url, notice: 'Bet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_bet
    @bet = Bet.find(params[:id])
  end

  def bet_params
    params.require(:bet).permit(:sport, :start_date, :country)
  end
end
