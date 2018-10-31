class WorkSerializer < ActiveModel::Serializer
  attributes :id, :title, :new_attribute

  def title  
    "#{"It is "}#{object.title}"
  end 

  def new_attribute
    "#{"some new attribute of work"}#{object.title}"
  end
end
