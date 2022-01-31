# frozen_string_literal: true

class Goal < ApplicationRecord
  validates :title, presence: true, length: { maximum: 180 }, allow_blank: false
  validate :end_date_is_after_start_date?

  has_many :key_results
  belongs_to :owner, class_name: "User"

  def progress
    return 0.0 if key_results.blank?

    (key_results.completed.count / key_results.count.to_f).round(2)
  end

  def progress_percentage
    progress * 100
  end

  private

  def end_date_is_after_start_date?
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, "can't be before to start_date") if end_date < start_date
  end
end
