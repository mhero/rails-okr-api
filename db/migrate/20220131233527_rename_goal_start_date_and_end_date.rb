# frozen_string_literal: true

class RenameGoalStartDateAndEndDate < ActiveRecord::Migration[7.0]
  def change
    rename_column :goals, :start_date, :started_at
    rename_column :goals, :end_date, :ended_at
  end
end
