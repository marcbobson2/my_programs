



class CircularBuffer
  class BufferEmptyException < Exception; end
    
  class BufferFullException < Exception; end

  def initialize(buffer_size)
    @buffer_size = buffer_size
    @circular_buffer = Array.new(buffer_size)
    @oldest_pointer = 0
    @next_empty_slot = 0
  end

  def read
    raise BufferEmptyException, "The buffer is empty!" if buffer_empty?
    read_value = @circular_buffer[@oldest_pointer]
    @circular_buffer[@oldest_pointer] = nil
    move_oldest_pointer
    read_value
  end

  def write(value)
    return if value == nil
    raise BufferFullException, "The buffer is full!" if buffer_full?
    @circular_buffer[@next_empty_slot] = value
    move_next_empty_slot_pointer
  end

  def write!(value)
    return if value == nil
    unless buffer_full? then
      write(value)
    else
      @circular_buffer[@oldest_pointer] = value
      move_oldest_pointer
    end
  end

  def display
    p @circular_buffer
  end
  
  def clear
    reset_pointers
    @circular_buffer.map! {|_| nil }
  end

  private

  def buffer_empty?
    # @circular_buffer.none?
    @circular_buffer[@oldest_pointer].nil?
  end

  def buffer_full?
    !@circular_buffer[@next_empty_slot].nil? 
  end

  def move_next_empty_slot_pointer
    @next_empty_slot == @buffer_size - 1 ? @next_empty_slot = 0 : @next_empty_slot += 1
  end

  def move_oldest_pointer
    @oldest_pointer == @buffer_size - 1 ? @oldest_pointer = 0 : @oldest_pointer += 1
  end

  def reset_pointers
    @oldest_pointer = 0
    @next_empty_slot = 0
  end
end