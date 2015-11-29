class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :done, :date_created, :last_updated_on

  def date_created
    object.created_at.strftime("%b %e, %Y. %l:%M %P")
  end

  def last_updated_on
    object.updated_at.strftime("%b %e, %Y. %l:%M %P")
  end
end
