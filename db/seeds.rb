# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create(username: "random", password: "letmein1")
Goal.create(title: "Run 21k in Stockholm", owner: user)
Goal.create(title: "Visit Japan", owner: user)

completed_goal = Goal.create(title: "Learn Swedish", owner: user, started_at: 1.month.ago, ended_at: 1.day.ago)

FactoryBot.create(:key_result, :completed, goal: completed_goal)
