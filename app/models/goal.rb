# == Schema Information
#
# Table name: goals
#
#  id         :integer          not null, primary key
#  title      :string(180)      not null
#  started_at :datetime
#  ended_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer
#  progress   :decimal(, )      default("0.0"), not null
#

# frozen_string_literal: true

class Goal < ApplicationRecord
  paginates_per 10

  validates :title, presence: true, length: { maximum: 180 }, allow_blank: false
  validate :ended_at_is_after_started_at?

  has_many :key_results

  belongs_to :owner, class_name: "User"

  accepts_nested_attributes_for :key_results

  def progress_percentage
    progress * 100
  end

  private

  def update_goal_progress
    UpdateGoalProgressWorker.perform_async(id)
  end

  def ended_at_is_after_started_at?
    return if ended_at.blank? || started_at.blank?

    errors.add(:ended_at, "can't be before to started_at") if ended_at < started_at
  end
end
