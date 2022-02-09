# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates_presence_of :username, :password_digest

  has_many :goals, foreign_key: :owner_id
end
