class Comment < ActiveRecord::Base
	belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
	
	belongs_to :post
	
	validates :body, presence: true
		has_many :votes, as: :voteable
	
	def total_votes
		self.votes.where(vote: true).size - self.votes.where(vote: false).size
	end
end