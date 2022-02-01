# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthenticateUser do
  # create test user
  let!(:user) { create(:user, password: "hola") }

  describe "#token" do
    context "when valid credentials" do
      subject { described_class.new(user.username, "hola") }

      it "returns an auth token" do
        token = subject.token
        expect(token).not_to be_nil
      end
    end

    context "when invalid credentials" do
      subject { described_class.new("foo", "bar") }

      it "raises an authentication error" do
        expect { subject.token }
          .to raise_error(
            ExceptionHandler::AuthenticationError,
            /Invalid credentials/
          )
      end
    end
  end
end
