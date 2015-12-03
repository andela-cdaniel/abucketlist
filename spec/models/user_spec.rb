require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { User.new(username: username, password: password) }
  let(:username) { "Ikem" }
  let(:password) { "securepassword" }

  it { expect(user).to be_valid }

  describe "#username" do
    context "When username is not present" do
      let(:username) { "" }
      it { expect(user).to be_invalid }
    end

    context "When the length of the username is less than 2" do
      let(:username) { "a" }
      it { expect(user).to be_invalid }
    end

    context "When the length of the username is greater than 50" do
      let(:username) { "a"*51 }
      it { expect(user).to be_invalid }
    end

    context "When the name contains invalid characters" do
      let(:username) { "Adekoye-=`78`9`++" }
      it { expect(user).to be_invalid }
    end

    context "When the username is not unique" do
      it "The user should be invalid" do
        user.save
        expect(User.first.username).to eql("ikem")
        u = User.new(username: username, password: password)
        expect(u).to be_invalid
      end
    end
  end

  describe "#password" do
    context "When the password is not present" do
      let(:password) { "" }
      it { expect(user).to be_invalid }
    end

    context "When the length of the password is less than 8 characters" do
      let(:password) { "s"*7 }
      it { expect(user).to be_invalid }
    end

    context "When the length of the password is greater than 255 characters" do
      let(:password) { "pass"*255 }
      it { expect(user).to be_invalid }
    end
  end

  describe "#authorize" do
    context "When the user credentials are correctly matched" do
      it "Returns the user record" do
        user.save
        result = User.authorize({username: username, password: password})
        expect(result).to be_a User
      end
    end

    context "When the user credentials are invalid" do
      it "Returns nil" do
        user.save
        result = User.authorize({username: "ikem", password: "notvalid"})
        expect(result).to be_nil
      end
    end
  end

  describe "#login" do
    it "Updates the user's logged in attribute as true" do
      user.save
      expect(user.logged_in).to be false
      User.login(user)
      expect(user.logged_in).to be true
    end
  end

  describe "#logout" do
    it "Updates the user's logged in attribute as false" do
      user.save
      User.login(user)
      expect(user.logged_in).to be true
      User.logout(user)
      expect(user.logged_in).to be false
    end
  end

  describe "#generate_jwt_token" do
    it "Returns a hash containing user, token and expires_on attributes" do
      jwtrecord = User.generate_jwt_token(user)
      expect(jwtrecord).to be_a Hash
      expect(jwtrecord[:user]).to eql("Ikem")
      expect(jwtrecord[:token]).to be_present
      expect(jwtrecord[:expires_on]).to be_present
    end
  end

  describe "User associations" do
    it "The user should have bucketlists belonging to the user" do
      user.save
      expect(user.id).to eql(1)
      generate_bucketlists_for(user, 5)
      expect(user.bucketlists.length).to eql(5)
      expect(user.bucketlists.first.created_by).to eql("1")
    end

    it "The user should have bucketlist items belonging to the user" do
      user.save
      expect(user.id).to eql(1)
      generate_items_for(user, 5)
      expect(user.bucketlists.first.items.length).to eql(5)
      expect(user.bucketlists.first.items.first.bucketlist_id).to eql("1")
    end

    it "When a user is destroyed, all it's associated bucketlist are destroyed as well" do
      user.save
      generate_bucketlists_for(user, 5)
      expect(user.bucketlists.length).to eql(5)
      user.destroy
      expect(user.bucketlists.length).to eql(0)
    end
  end
end
