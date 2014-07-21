class FlashcardsController < ApplicationController
  before_action :correct_user
  #before_action :get_flashcard_show, only: :show
  before_action :get_flashcard, except: [:new, :create, :index]

  def index
    card_number = params[:page] || 1
    @flashcards = @deck.flashcards.paginate(page: card_number.to_i, per_page: 1)
    @flashcard = @deck.flashcards[card_number.to_i-1]
  end
  
  def new
    @flashcard = @deck.flashcards.build
  end

  def create
    @flashcard = @deck.flashcards.build(flashcard_params)
    if @flashcard.save
      flash[:info] = "Flashcard Added."
      redirect_to @deck
    else
      render 'new'
    end
  end

  def show
    @flashcards = @deck.flashcards.paginate(page: params[:page], per_page: 1)
    @front_content = @flashcard.side_one
    @back_content = @flashcard.side_two
  end

  def edit

  end

  def update
    if @flashcard.update_attributes(flashcard_params)
      flash[:success] = "Flashcard updated successully."
      redirect_to deck_flashcards_path(@deck, page: params[:page])
    else
      render 'edit'
    end
  end


  def destroy
    @flashcard.destroy
    card_index = (params[:page].to_i <= 1 ? 1 : params[:page].to_i - 1)
    flash[:info] = "Flashcard was removed from deck"
    redirect_to deck_flashcards_path(@deck, page: card_index)
  end

private

  def flashcard_params
      params.require(:flashcard).permit(:side_one, :side_two)
  end

  def correct_user
    @deck = Deck.find(params[:deck_id])
    unless @deck.belongs_to?(current_user)
      flash[:danger] = "You are not authorized to do that"
      redirect_to root_path
    end
  end

  def get_flashcard
    @flashcard = Flashcard.find(params[:id])
  end


end
