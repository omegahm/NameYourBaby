class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :decided_names, dependent: :destroy
end
