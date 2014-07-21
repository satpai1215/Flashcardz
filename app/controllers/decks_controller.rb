class DecksController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, except: [:new, :create, :index]    


  def new
    @deck = current_user.decks.build
  end

  def create
    @deck = current_user.decks.build(deck_params)
    if @deck.save
      redirect_to deck_path(@deck), notice: "Deck created successfully."
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
      redirect_to decks_path, notice: "Deck successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @deck.destroy
    redirect_to decks_path, notice: "Deck deleted successfully"
  end


private
  def deck_params
      params.require(:deck).permit(:title)
  end

  def signed_in_user
    redirect_to root_path, notice: "You must be signed in to do that." unless signed_in?
  end

  def correct_user
    @deck = Deck.find(params[:id])
    unless @deck.belongs_to?(current_user)
      redirect_to root_path, notice: "You are not authorized to do that"
    end
  end



end
