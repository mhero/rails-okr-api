# frozen_string_literal: true

class SerializableKeyResult < JSONAPI::Serializable::Resource
  type "key_result"

  attributes :title, :goal_id, :started_at, :completed_at, :created_at

  attributes :status do
    @object.status
  end
end
