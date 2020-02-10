class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :count
      t.integer :price_in_cents
    end
  end
end
