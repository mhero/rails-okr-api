# frozen_string_literal: true

class SerializableGoal < JSONAPI::Serializable::Resource
  type "goal"

  has_many :key_results

  attributes :title, :created_at, :start_date, :end_date

  attribute :progress do
    "#{@object.progress_percentage}%"
  end
end
