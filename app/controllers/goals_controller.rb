# frozen_string_literal: true

class GoalsController < ApplicationController
  before_action :set_goal_owner, only: [:create]

  def index
    goals = Goal.where(owner: current_user).includes(:key_results)
    render jsonapi: goals, status: :ok
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

  private

  def set_goal_owner
    @owner = User.find_by(id: owner_params[:owner_id]) || current_user
  end

  def owner_params
    params.require(:goal).permit(:owner_id)
  end

  def permitted_params
    params.require(:goal).permit(:title, :start_date, :end_date)
  end
end
