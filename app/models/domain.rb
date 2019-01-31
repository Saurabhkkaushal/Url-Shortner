class Domain < ApplicationRecord
	def self.check_presence_of_domain(domain_name)
		Domain.find_by_long_domain(domain_name)


	end
end
