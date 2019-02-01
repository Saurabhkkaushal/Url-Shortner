class Dailyreport < ApplicationRecord
	validates :date_today , uniqueness: true , null: false
	validates :count , presence: true , null: false
end
