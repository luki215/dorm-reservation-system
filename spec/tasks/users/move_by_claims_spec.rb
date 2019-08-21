require "rails_helper"

describe "rake generators:users:move_by_claims", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "runs gracefully" do
    expect { task.execute }.not_to raise_error
  end

  it ""

end