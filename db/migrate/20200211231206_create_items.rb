class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :count
      t.integer :price_in_cents
      t.integer :producer_id
    end
  end
end
