# frozen_string_literal: true

class Goal < ApplicationRecord
  paginates_per 10

  validates :title, presence: true, length: { maximum: 180 }, allow_blank: false
  validate :end_date_is_after_start_date

  has_many :key_results, dependent: :destroy
  belongs_to :owner, class_name: "User"

  def progress_percentage
    progress * 100
  end

  private

  def update_goal_progress
    UpdateGoalProgressWorker.perform_async(id)
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, "can't be before to start_date") if end_date < start_date
  end
end
