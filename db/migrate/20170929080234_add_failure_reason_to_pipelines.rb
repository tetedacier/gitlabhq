class AddFailureReasonToPipelines < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    add_column :ci_pipelines, :failure_reason, :integer
  end
end
