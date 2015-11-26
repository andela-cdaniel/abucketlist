class BucketlistSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_by, :date_created, :last_updated_on

  has_many :items, dependent: :destroy

  def date_created
    object.created_at.strftime("%b %e, %Y. %l:%M %P")
  end

  def last_updated_on
    object.updated_at.strftime("%b %e, %Y. %l:%M %P")
  end
end
