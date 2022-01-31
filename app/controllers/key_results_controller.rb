# frozen_string_literal: true

class KeyResultsController < ApplicationController
  before_action :set_goal, only: [:create]

  def create
    key_result = @goal.key_results.new(permitted_params)

    if key_result.save
      render jsonapi: key_result, status: :created
    else
      render json: { errors: key_result.errors }, status: :bad_request
    end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def permitted_params
    params.require(:key_result).permit(:title, :started_at, :completed_at)
  end
end
