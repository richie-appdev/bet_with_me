class BetsController < ApplicationController
  before_action :current_user_must_be_bet_bet_starter, :only => [:edit, :update, :destroy]

  def current_user_must_be_bet_bet_starter
    bet = Bet.find(params[:id])

    unless current_user == bet.bet_starter
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @bets = Bet.page(params[:page]).per(10)

    render("bets/index.html.erb")
  end

  def show
    @follow = Follow.new
    @bet = Bet.find(params[:id])

    render("bets/show.html.erb")
  end

  def new
    @bet = Bet.new

    render("bets/new.html.erb")
  end

  def create
    @bet = Bet.new

    @bet.name = params[:name]
    @bet.description = params[:description]
    @bet.value = params[:value]
    @bet.owner = params[:owner]

    save_status = @bet.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/bets/new", "/create_bet"
        redirect_to("/bets")
      else
        redirect_back(:fallback_location => "/", :notice => "Bet created successfully.")
      end
    else
      render("bets/new.html.erb")
    end
  end

  def edit
    @bet = Bet.find(params[:id])

    render("bets/edit.html.erb")
  end

  def update
    @bet = Bet.find(params[:id])

    @bet.name = params[:name]
    @bet.description = params[:description]
    @bet.value = params[:value]
    @bet.owner = params[:owner]

    save_status = @bet.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/bets/#{@bet.id}/edit", "/update_bet"
        redirect_to("/bets/#{@bet.id}", :notice => "Bet updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Bet updated successfully.")
      end
    else
      render("bets/edit.html.erb")
    end
  end

  def destroy
    @bet = Bet.find(params[:id])

    @bet.destroy

    if URI(request.referer).path == "/bets/#{@bet.id}"
      redirect_to("/", :notice => "Bet deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Bet deleted.")
    end
  end
end
