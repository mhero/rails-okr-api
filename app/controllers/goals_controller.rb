# frozen_string_literal: true

class GoalsController < ApplicationController
  before_action :set_goal_owner, only: [:create]
  skip_before_action :authorize_request, only: [:batch]

  def index
    goals = Goal
            .where(owner: current_user)
            .includes(:key_results)
            .page(params[:page])

    render jsonapi: goals, include: [:key_results], status: :ok
  end

  def create
    goal = Goal.new(permitted_params)
    goal.owner = @owner

    if goal.save
      render jsonapi: goal, status: :created
    else
      render json: goal.errors, status: :bad_request
    end
  end

  def batch
    goals = Goal.create(build_batch_params)
    valid_goals = goals.select(&:persisted?)

    render jsonapi: valid_goals,
           include: [:key_results],
           status: :created
  end

  private

  def build_batch_params
    permitted_batch_params[:goals].map do |goal_param|
      goal_param[:owner_id] = permitted_batch_params[:owner_id]
      goal_param
    end
  end

  def set_goal_owner
    @owner = User.find_by(id: owner_params[:owner_id]) || current_user
  end

  def permitted_batch_params
    params.permit(
      :owner_id,
      goals: [
        :title,
        :started_at,
        :ended_at,
        { key_results_attributes: [:title] }
      ]
    )
  end

  def owner_params
    params.require(:goal).permit(:owner_id)
  end

  def permitted_params
    params.require(:goal).permit(:title, :started_at, :ended_at)
  end
end
