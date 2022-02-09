# == Schema Information
#
# Table name: key_results
#
#  id           :integer          not null, primary key
#  title        :string(180)      not null
#  started_at   :datetime
#  completed_at :datetime
#  goal_id      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# frozen_string_literal: true

class KeyResult < ApplicationRecord
  validates :title, presence: true, length: { maximum: 180 }, allow_blank: false

  scope :in_progress, -> { where.not(started_at: nil).where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  belongs_to :goal

  after_commit :update_goal_progress, on: %i[create update]

  def status
    if in_progress?
      :in_progress
    elsif completed?
      :completed
    else
      :non_started
    end
  end

  def in_progress?
    started_at.present? && completed_at.nil?
  end

  def completed?
    completed_at.present?
  end

  private

  def new_record_or_completed_at_changed?
    saved_change_to_attribute?(:created_at) || saved_change_to_attribute?(:completed_at)
  end

  def update_goal_progress
    UpdateGoalProgressWorker.perform_async(goal_id) if new_record_or_completed_at_changed?
  end
end
