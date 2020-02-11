class AddProducerIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :producer_id, :integer
  end
end
