# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Goal management", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { valid_headers }

  describe "GET /goals" do
    let!(:goals) { create_list(:goal, 3, owner: current_user) }

    let(:other_user) { create(:user) }
    let!(:other_goals) { create_list(:goal, 2, owner: other_user) }

    it "returns status code 200" do
      get "/goals", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "returns the goals of the current user" do
      get "/goals", headers: headers

      json_response = JSON.parse(response.body)["data"]

      aggregate_failures do
        expect(json_response.size).to eq(3)
        expect(json_response.pluck("id")).to match_array(goals.pluck(:id).map(&:to_s))
      end
    end
  end

  describe "POST /goals" do
    describe "with valid params" do
      let(:request_params) { { goal: { title: "Learn" } }.to_json }

      it "returns status code 201" do
        post "/goals", params: request_params, headers: headers

        expect(response).to have_http_status(:created)
      end

      it "creates a new goal with the current user as the owner" do
        post "/goals", params: request_params, headers: headers

        expect(Goal.last.owner).to eq current_user
      end

      context "When a different goal owner is specified" do
        let!(:goal_owner) { create(:user) }

        let(:request_params) do
          {
            goal: {
              title: "Learn",
              owner_id: goal_owner.id
            }
          }.to_json
        end

        it "creates a new goal with the user as owner" do
          post "/goals", params: request_params, headers: headers

          expect(Goal.last.owner).to eq goal_owner
        end
      end
    end

    describe "with invalid params" do
      let(:request_params) { { goal: { title: "" } }.to_json }

      it "returns 404" do
        post "/goals", params: request_params, headers: headers
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
