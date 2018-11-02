class WorkSerializer
  def initialize(work_obj)
    @works_array = []
    case work_obj.class.name
    when "ActiveRecord::Relation"  #if there are more works
      work_obj.each do |work|
        @works_array << work
      end
    when "Work"  #if there are only one work
      @works_array << work_obj
    end
  end

  def work_as_json(work)
    work_hash = 
      {
        id: work.id,
        title: work.title
      }
  end

  def as_json
    @json_hash = {works: []}
    @works_array.each do |work|
      work_hash = work_as_json(work)
      @json_hash[:works] << work_hash
    end
    return @json_hash
  end
end
