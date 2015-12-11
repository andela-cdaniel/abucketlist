require "rails_helper"

RSpec.describe Item, type: :model do
  subject(:item) { Item.new(name: name, bucketlist_id: id) }
  let(:name) { "My items" }
  let(:id) { "1" }

  it { expect(item).to be_valid }

  describe "#name" do
    context "When name is not present" do
      let(:name) { "" }
      it { expect(item).to be_invalid }
    end

    context "When the length of the name is less than 4" do
      let(:name) { "abc" }
      it { expect(item).to be_invalid }
    end

    context "When the length of the name is greater than 144" do
      let(:name) { "aa" * 144 }
      it { expect(item).to be_invalid }
    end

    context "When the name contains invalid characters" do
      let(:name) { "New Item-=`78`9`++" }
      it { expect(item).to be_invalid }
    end

    context "When the name is not unique" do
      it "The item should be invalid" do
        item.save
        expect(item.name).to eql("My items")
        i = Item.new(name: name, bucketlist_id: id)
        expect(i).to be_invalid
      end
    end
  end

  describe "#bucketlist_id" do
    context "When the bucketlist_id is not present" do
      let(:id) { "" }
      it { expect(item).to be_invalid }
    end
  end

  describe "Item associations" do
    it "The item should belong to a bucketlist" do
      item.save
      expect(item.id).to eql(1)
      Bucketlist.create(name: "Bucket1", created_by: "1")
      bucket_item = Bucketlist.find(1).items.find_by_bucketlist_id(1)
      expect(bucket_item.name).to eql("My items")
    end
  end
end
