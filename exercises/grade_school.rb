class School
  def initialize
    @student_roster = {}
  end
  
  def to_h
    return @student_roster if @student_roster.size < 2
    @student_roster = sort_hash
  end
  
  def add(student, grade)
      @student_roster[grade] = [] if @student_roster[grade].nil?
      @student_roster[grade] << student
  end
  
  def grade(grade_num)
    @student_roster[grade_num] || [] 
  end
  
  private
  
  def sort_hash
    @student_roster.sort.to_h.each { |_, value| value.sort! }
  end
end