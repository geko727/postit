class Category < ActiveRecord::Base
	has_many :post_categories
	has_many :post, through: :post_categories
end