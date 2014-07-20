class AddCardIdToDecks < ActiveRecord::Migration
  def change
    add_column :flashcards, :card_id, :integer
  end
end

