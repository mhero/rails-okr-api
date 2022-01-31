# frozen_string_literal: true

class AddKeyResults < ActiveRecord::Migration[7.0]
  def change
    create_table(:key_results) do |t|
      t.column :title, :string, limit: 180, null: false
      t.column :started_at, :datetime, null: true
      t.column :completed_at, :datetime, null: true

      t.references :goal, foreign_key: true, null: false

      t.timestamps
    end
  end
end
