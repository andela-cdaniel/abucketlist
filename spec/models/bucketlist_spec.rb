require "rails_helper"

RSpec.describe Bucketlist, type: :model do
  subject(:bucketlist) { Bucketlist.new(name: name, created_by: id) }
  let(:name) { "My bucket" }
  let(:id) { "1" }

  it { expect(bucketlist).to be_valid }

  describe "#name" do
    context "When name is not present" do
      let(:name) { "" }
      it { expect(bucketlist).to be_invalid }
    end

    context "When the length of the name is less than 4" do
      let(:name) { "abc" }
      it { expect(bucketlist).to be_invalid }
    end

    context "When the length of the name is greater than 144" do
      let(:name) { "aa"*144 }
      it { expect(bucketlist).to be_invalid }
    end

    context "When the name contains invalid characters" do
      let(:name) { "New bucketlist-=`78`9`++" }
      it { expect(bucketlist).to be_invalid }
    end

    context "When the name is not unique" do
      it "The bucketlist should be invalid" do
        bucketlist.save
        expect(bucketlist.name).to eql("My bucket")
        b = Bucketlist.new(name: name, created_by: id)
        expect(b).to be_invalid
      end
    end
  end

  describe "#created_by" do
    context "When the created_by value is not present" do
      let(:id) { "" }
      it { expect(bucketlist).to be_invalid }
    end
  end

  describe "Bucketlist associations" do
    it "The bucketlist should belong to a user" do
      bucketlist.save
      expect(bucketlist.id).to eql(1)
      User.create(username: "Ikem", password: "ikemefunaodimgwaone")
      bucket = User.find(1).bucketlists.find_by_created_by(1)
      expect(bucket.name).to eql("My bucket")
    end

    it "The bucketlist should have many items" do
      bucketlist.save
      expect(bucketlist.id).to eql(1)
      Item.create(name: "Bucket items", bucketlist_id: "1")
      expect(bucketlist.items.first.name).to eql("Bucket items")
    end

    it "When a bucketlist is destroyed, all it's associated items are destroyed as well" do
      bucketlist.save
      i = Item.create(name: "Bucket item", bucketlist_id: 1)
      expect(bucketlist.items.length).to eql(1)
      bucketlist.destroy
      expect(bucketlist.items.length).to eql(0)
    end
  end
end
