# frozen_string_literal: true

class UpdateGoalProgressWorker
  include Sidekiq::Worker

  def perform(goal_id)
    UpdateGoalProgressService.new(goal_id:).call
  end
end
