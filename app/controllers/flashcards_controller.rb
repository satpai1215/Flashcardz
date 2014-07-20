class FlashcardsController < ApplicationController
  before_action :correct_user
  before_action :get_flashcard_show, only: :show
  before_action :get_flashcard, except: [:new, :create, :show]

  def show
    @flashcards = @deck.flashcards.order('created_at ASC')
    @front_content = @flashcard.side_one
    @back_content = @flashcard.side_two

  end

  def new
    @flashcard = @deck.flashcards.build
  end

  def create
    @flashcard = @deck.flashcards.build(flashcard_params)
    if @flashcard.save
      redirect_to @deck, notice: "Flashcard Added"
    else
      render 'new'
    end

  end

  def edit
  end

  def update
    if @flashcard.update_attributes(flashcard_params)
      flash[:success] = "Flashcard updated successully."
      redirect_to deck_flashcard_path(@deck, @flashcard)
    else
      render 'edit'
    end
  end


  def destroy
    @flashcard.destroy
    redirect_to @deck, notice: "Flashcard was removed from deck"
  end

private

  def flashcard_params
      params.require(:flashcard).permit(:side_one, :side_two)
  end

  def correct_user
    @deck = Deck.find(params[:deck_id])
    unless @deck.belongs_to?(current_user)
      redirect_to root_path, notice: "You are not authorized to do that"
    end
  end

  def get_flashcard
    @flashcard = @deck.flashcards.find(params[:id])
  end

  def get_flashcard_show
    @flashcard = @deck.flashcards[params[:card_id].to_i - 1]
  end

end
