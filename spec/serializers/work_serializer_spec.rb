require 'rails_helper'

RSpec.describe WorkSerializer do
  
  #return a array with more serialized works
  def serialize_more_works(works)
    serialized_works = Array.new
    
    works.each do |work|
      serialized_works << { id: work.id,
                            title: work.title
                          }
    end 

    return serialized_works
  end
  
  #return a array with one serialized work
  def serialize_one_work(work)
    [{ id: work.id,
      title: work.title
    }]
  end

  context " - serialization of one correct work object" do
    context " - work with everything" do
      let(:work) { create(:work) }
      let(:serialized_work) { serialize_one_work(work) }

      it " - should return a array with serialized work" do
        expect(WorkSerializer.new(work).as_json).to match(serialized_work)
      end
    end
  end

  context " - serialization of more correct works like ActiveRecord::Relation" do
    before(:each) do
      3.times.map { create(:work) }
      @works = Work.all
      @serialized_works = serialize_more_works(@works)
    end

    it " - should return a array with serialized works" do
      expect(WorkSerializer.new(@works).as_json).to match(@serialized_works)
    end
  end

  context " - serialization of unexpected object" do
    it " - should return a empty array" do
      expect(WorkSerializer.new("").as_json).to match([])
      expect(WorkSerializer.new(nil).as_json).to match([])
      expect(WorkSerializer.new([]).as_json).to match([])
      expect(WorkSerializer.new([Work.new]).as_json).to match([])
      expect(WorkSerializer.new([Work.last]).as_json).to match([])
      expect(WorkSerializer.new(User.new).as_json).to match([])
    end
  end
end