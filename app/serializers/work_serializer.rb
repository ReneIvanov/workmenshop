class WorkSerializer
  def initialize(work_obj)
    @works_array = []
    case 
    when work_obj.is_a?(Work)   #if there are only one work
      @works_array << work_obj
    when work_obj.is_a?(ActiveRecord::Relation)  #if there are more works
      work_obj.each do |work|
        @works_array << work
      end
    end  
  end

  def work_as_json(work)
    work_hash = {}
    work_hash.merge!(id: work.id)
    work_hash.merge!(title: work.title)
    return work_hash
  end

  def as_json
    @json_array = []
    @works_array.each do |work|
      work_hash = work_as_json(work)
      @json_array << work_hash
    end
    return @json_array
  end
end
