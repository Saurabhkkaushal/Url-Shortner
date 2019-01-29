class Dailyreport < ApplicationRecord
	validates :date_today , presence: true , uniqueness: true , null: false
	validates :count , presence: true , uniqueness: true , null: false
end
