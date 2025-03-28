class DecidedName < ApplicationRecord
  belongs_to :user
  belongs_to :name

  scope :liked, ->(user) { where(user: user, decision: true).joins(:name).order("names.name") }
end
