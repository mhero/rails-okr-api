# frozen_string_literal: true

class SerializableGoal < JSONAPI::Serializable::Resource
  type "goal"

  has_many :key_results

  attributes :title, :created_at, :started_at, :ended_at

  attribute :progress do
    "#{@object.progress_percentage}%"
  end
end
