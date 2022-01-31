# frozen_string_literal: true

class AllowNullForGoalStartAndEndDate < ActiveRecord::Migration[7.0]
  def change
    change_column_null :goals, :start_date, true
    change_column_null :goals, :end_date, true
  end
end
