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

  def update_goal_progress
    return unless saved_change_to_attribute?(:completed_at) || saved_change_to_attribute?(:created_at)
    UpdateGoalProgressWorker.perform_async(goal_id)
  end
end
