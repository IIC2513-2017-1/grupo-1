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
      flash[:alert] = 'Debe elegir alguna apuesta'
      redirect_to root_path
    end
    @users = User.all
  end

  def create_grand
    grand = Grand.new(amount: params[:amount], user_id: params[:user_id])
    user = User.find(params[:user_id])
    unless grand.save && grand.amount <= user.money
      flash[:alert] = 'Grand no fue creado'
      redirect_to root_path
      return
    end
    bets_id = params.select { |_, v| v == '-1' }.map { |i| i[0] }
    bets_id.each do |bet_id|
      MakeUp.create(grand_id: grand.id,
                    bet_id: bet_id,
                    selection: params["competitors#{bet_id}"])
    end
    final_date = DateTime.current - 1.years
    grand.bets.each do |bet|
      final_date = bet.start_date if final_date < bet.start_date
    end
    grand.end_date = final_date
    grand.save
    flash[:notice] = 'Grand fue creado con exito'
    user.money -= grand.amount
    user.save
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
    params.require(:bet).permit(:sport, :start_date, :country, :pay_per_tie)
  end

  def get_multiplicator(grand)
    multiplier = 1
    grand.bets_per_grand do |bet|
      selection = bet.selection
      mul = bet.bet.competitors_per_bet.find_by(competitor_id:
       selection).multiplicator
      multiplier *= mul
    end
    multiplier
  end
end
