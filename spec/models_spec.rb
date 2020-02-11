require_relative 'spec_helper'

describe 'Producer' do
  before do
    @producer = Producer.create(name: 'Jimmy McTestface', email: 'test@testejo.com', password: 'password')
  end
  
  it 'has a name and email' do
    expect(@producer.name).to eq('Jimmy McTestface')
    expect(@producer.email).to eq('test@testejo.com')
  end

  it 'does not store plaintext password' do
    expect(@producer.password_digest).to be_truthy
    p = Producer.find_by(name: 'Jimmy McTestface')
    expect(p.password).not_to eq('password')
  end
end

describe 'Item' do
  before do
    @item = Item.create(name: "Jimmy's Tomatoes", count: 4, price_in_cents: 100)
  end

  it 'has a name, count and price in cents' do
    expect(@item.name).to eq("Jimmy's Tomatoes")
    expect(@item.count).to eq(4)
    expect(@item.price_in_cents).to eq(100)
  end

  it 'can output price in dollars' do
    expect(@item.price).to eq('$1.00')
  end

  it 'correctly outputs price less than $1' do
    @item.price_in_cents = 50
    expect(@item.price).to eq('$.50')
  end
end

describe 'Producer-Item Associations' do
  before do
    @producer = Producer.create(name: "Jimmy McTestface", email: 'test@testejo.com', password: 'password')
    @item1 = Item.create(name: "Jimmy's Tomatoes", count: 4, price_in_cents: 100, producer_id: @producer.id)
    @item2 = Item.create(name: "Jimmy's Potatoes", count: 23, price_in_cents: 50, producer_id: @producer.id)
  end

  it 'has one owner for each item' do
    expect(@item1.producer).to eq(@producer)
    expect(@item2.producer).to eq(@producer)
  end

  it 'has many items for each producer' do
    expect(@producer.items).to include(@item1)
    expect(@producer.items).to include(@item2)
  end

  it 'responds correctly to item deletion' do
    @item1.delete
    expect(@producer.items).not_to include(@item1)
  end
end