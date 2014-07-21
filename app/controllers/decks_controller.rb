class DecksController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, except: [:new, :create, :index]    


  def new
    @deck = current_user.decks.build
  end

  def create
    @deck = current_user.decks.build(deck_params)
    if @deck.save
      flash[:info] = "Deck created successfully."
      redirect_to deck_path(@deck)
    else
      render 'new'
    end
  end

  def index
    @decks = current_user.decks.paginate(page: params[:page], per_page: 20)
  end

  def show
    @flashcards = @deck.flashcards
  end

  def edit
  end

  def update
    if @deck.update_attributes(deck_params)
       flash[:info] = "Deck successfully updated."
      redirect_to @deck
    else
      render 'edit'
    end
  end

  def destroy
    @deck.destroy
    flash[:info] = "Deck deleted successfully."
    redirect_to decks_path
  end


private
  def deck_params
      params.require(:deck).permit(:title)
  end

  def signed_in_user
    unless signed_in?
      flash[:info] = "You must be signed in to do that."
      redirect_to root_path
    end
  end

  def correct_user
    @deck = Deck.find(params[:id])
    unless @deck.belongs_to?(current_user)
      flash[:info] = "You are not authorized to do that"
      redirect_to root_path
    end
  end



end
