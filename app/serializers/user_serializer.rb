class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :created_on

  def created_on
    object.created_at.strftime("%b %e, %Y")
  end
end
