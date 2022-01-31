# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Goal management", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { valid_headers }
  let!(:goal) { create(:goal) }

  describe "with valid params" do
    let(:request_params) { { key_result: { title: "New key result" } }.to_json }

    it "creates a new key result" do
      post "/goals/#{goal.id}/key_results", params: request_params, headers: headers
      expect(response).to have_http_status(:created)
    end
  end

  describe "with invalid params" do
    let(:request_params) { { key_result: { title: "" } }.to_json }

    it "returns 404" do
      post "/goals/#{goal.id}/key_results", params: request_params, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
