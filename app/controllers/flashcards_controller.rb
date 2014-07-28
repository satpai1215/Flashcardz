require 'roo'

class FlashcardsController < ApplicationController
  before_action :correct_user
  #before_action :get_flashcard_show, only: :show
  before_action :get_flashcard, except: [:new, :create, :index, :upload_cards, :new_from_file]

  def index
    card_number = params[:page] || 1
    card_number = card_number.to_i
    @flashcards = @deck.flashcards.paginate(page: card_number, per_page: 1)
    @flashcard = @deck.flashcards[card_number - 1]

  
    @random_index = Random.rand(1..@deck.flashcards.length)
  end
  
  def new
    @flashcard = @deck.flashcards.build
  end

  def new_from_file
  end

  def upload_cards
    sheet = open_spreadsheet(params[:spreadsheet_path])
    
    if sheet
      (1..sheet.last_row).each do |r|
        row = sheet.row(r)
        side_one = row[0]
        side_two = row[1]

       @deck.flashcards.create(side_one: side_one, side_two: side_two)
      end
      flash[:info] = "Flashcards Uploaded Successfully."
      redirect_to @deck
    else
      flash[:danger] = "Incorrect File Type"
      redirect_to deck_new_from_file_path
    end
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

  def open_spreadsheet(file)
    if file.nil?
      false
    else
      case File.extname(file.original_filename)
      when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
      when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
      when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
      else false
      end
    end
  end


end
