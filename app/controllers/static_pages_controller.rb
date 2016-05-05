class StaticPagesController < ApplicationController
	def home
		@categories = Category.all
		@state = State.all
	end


	def about_us

	end

	def carriers
		
	end

	def terms
		
	end

	def policy
		
	end
end
