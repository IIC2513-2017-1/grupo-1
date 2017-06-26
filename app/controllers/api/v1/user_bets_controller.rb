module Api::V1
  class UserBetsController < ApiController
    before_action :authenticate

    def index
      @user = User.find(params[:user_id])
      @status = true
      @status = false if @current_user != @user && !@current_user.admin?
      @user_bets = @user.user_bets
    end

    def show
      @user_bet = UserBet.find(params[:id])
      @user = User.find(params[:user_id])
      @mostra = false
      return unless @user == @current_user || @current_user.admin?
      @mostra = true
      if @user_bet.exclusive
        @mostra = false unless @user_bet.user.following.include?(@current_user)
      end
    end

    def create
      @user = User.find(params[:user_id])
      unless @user == @current_user
        @status = 'Acceso no autorizado'
        return
      end
      params.require(:user_bet).permit(:name, :description, :challenger_amount,
                                       :gambler_amount, :bet_limit, :start_date,
                                       :end_date, :exclusive)
      UserBet.transaction do
        @user_bet = UserBet.new(user_bet_params.merge(user_id:
                                                      @current_user.id))
        @user_bet.save!
        save_money(@user_bet)
      end
    rescue => invalid
      @status = invalid
    else
      admin = User.where(role: 'admin').order('RANDOM()').first
      admin.bet_assignations << @user_bet
      @status = 'MeesBet creada'
    end

    def obtener_resultado
      if @current_user.admin?
        @user_bet = UserBet.find(params[:bet_id].to_i)
        unless @user_bet.result.nil? && @user_bet.checked == true
          @status = 'La apuesta no está lista'
          return
        end
        @user = @user_bet.user
        @user_bet.result = params[:result].to_i
        if @user_bet.save
          repartir @user_bet
          UserBetMailer.finished_user_bet_email(@user, @user_bet).deliver_now
          @user_bet.bettors.each do |bettor|
            UserBetMailer.finished_user_bet_email(bettor, @user_bet).deliver_now
          end
          @status = 'check'
          if @user_bet.result == 1
            @result = 'Gana challenger'
          elsif @user_bet.result == 2
            @result = 'Gana gambler'
          else
            @result = 'Empate'
          end
        else
          @status = 'Ocurrió un error inesperado'
        end
      else
        @status = 'Acceso no autorizado'
      end
    end

    def accept_a_bet
      p 'lalalalalaalllalalalal'
      user = @current_user
      @bet = UserBet.find(params[:bet_id].to_i)
      @result = accept_user_bet(user, @bet)
    end

    private

    def accept_user_bet(user, bet)
      UserBet.transaction do
        if bet.gambler_amount > user.money || bet.bet_limit <= 0 \
              || bet.start_date < DateTime.current
          return :alert, 'No se pudo ejecutar la apuesta'
        else
          user.money -= bet.gambler_amount
          bet.bet_limit -= 1
          user.save!
          bet.save!
        end
      end
    rescue => invalid
      return :alert, invalid
    else
      user.accepted_bets << bet
      return :success, 'Apuesta realizada correctamente'
    end

    def save_money(user_bet)
      user = user_bet.user
      if user.money < user_bet.bet_limit * user_bet.challenger_amount
        raise 'No posee el dinerin suficiente'
      end
      user.money -= user_bet.bet_limit * user_bet.challenger_amount
      user.save
    end

    def repartir(user_bet)
      user_bet.user.money += user_bet.bet_limit * user_bet.challenger_amount
      user_bet.bettors.each do |bettor|
        if user_bet.result == 1
          user_bet.user.money += user_bet.challenger_amount +
                                 user_bet.gambler_amount
        elsif user_bet.result == 2
          bettor.money += user_bet.challenger_amount + user_bet.gambler_amount
          bettor.save
        else
          bettor.money += user_bet.gambler_amount
          user_bet.user.money += user_bet.challenger_amount
          bettor.save
        end
      end
      user_bet.user.save
    end
  end
end
