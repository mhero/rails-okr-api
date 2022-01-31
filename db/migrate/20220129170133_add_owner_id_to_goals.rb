# frozen_string_literal: true

class AddOwnerIdToGoals < ActiveRecord::Migration[7.0]
  def change
    add_reference :goals, :owner, foreign_key: { to_table: :users }
  end
end
