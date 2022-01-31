# frozen_string_literal: true

class AddGoals < ActiveRecord::Migration[7.0]
  def change
    create_table(:goals) do |t|
      t.column :title, :string, limit: 180, null: false
      t.column :start_date, :datetime, null: false
      t.column :end_date, :datetime, null: false

      t.timestamps
    end
  end
end
