class SimpleLinkedList
  attr_reader :size, :head

  def initialize
    @size = 0
    @head = nil
  end

  def push(value)
    @head = Element.new(value, @head)
    @size += 1
  end

  def empty?
    size == 0
  end

  def peek
    size != 0 ? @head.datum : nil
  end

  def pop
    return nil if @size == 0
    @size -= 1
    temp_head = @head.next_element # temporarily store the new head
    datum = @head.datum # store the datum of current head
    @head.next_element = nil # kill the pointer of current head
    @head = temp_head # reassign temp_head to become the new head
    datum # pass back the datum from the old (dead) head
  end

  def self.from_a(arr)
    new_list = SimpleLinkedList.new
    arr.reverse.each {|element| new_list.push(element) } if arr && arr.size != 0
    new_list
  end

  def to_a
    return [] if size == 0
    result = Array.new([@head.datum])
    element = @head.next
    while element != nil do
      result << element.datum
      element = element.next
    end
    result
  end

  def reverse
    SimpleLinkedList.from_a(self.to_a.reverse)
  end

end


class Element
  attr_reader :datum, :next_element

  def initialize(value, next_element = nil)
    @datum = value
    @next_element = next_element
  end

  def tail?
    next_element == nil
  end

  def next
    next_element ? next_element : nil
  end

  def next_element=(value)
    @next_element = value
  end

end

#list = SimpleLinkedList.from_a ([1,2,3,4,5])
#p list.to_a
#6.times { |_| p list.pop }







