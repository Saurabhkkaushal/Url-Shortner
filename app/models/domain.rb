class Domain < ApplicationRecord

	validates :long_domain , null: false , uniqueness: true
	validates :short_domain , null: false , uniqueness: true
	def self.check_presence_of_domain(domain_name)
		Domain.find_by_long_domain(domain_name)
	end
end
