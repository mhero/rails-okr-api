class UpdateGoalProgressService
  def initialize(goal_id:)
    @goal = Goal.find(goal_id)
  end

  def call
    @goal.update(progress: calculate_progress)
  end

  private

  def calculate_progress
    key_results = @goal.key_results

    return 0.0 if key_results.blank?

    (key_results.completed.count / key_results.count.to_f).round(2)
  end
end