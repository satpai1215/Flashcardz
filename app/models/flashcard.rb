class Flashcard < ActiveRecord::Base
	belongs_to :deck

	before_create :set_card_id

	def to_param
		card_id
	end

	def self.from_param
		id
	end

	private

	#creates a deck specific id for this flashcard (rather than using the Activerecord id)
	def set_card_id
		self.card_id = self.deck.flashcards.count + 1
	end

end
