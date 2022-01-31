# frozen_string_literal: true

class KeyResult < ApplicationRecord
  validates :title, presence: true, length: { maximum: 180 }, allow_blank: false

  scope :in_progress, -> { where.not(started_at: nil).where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  belongs_to :goal

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
end
