require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require "minitest/reporters"


Minitest::Reporters.use!

require_relative 'todolist'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    
    
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    
    #@list.mark_all_done
  end

  # Your tests go here. Remember they must start with "test_"
  def test_todo1
    assert_equal(@todo1.title, "Buy milk")
  end
  
  def test_to_a
    assert_equal(@todos, @list.to_a)
  end
  
  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end
  
  def test_last
    assert_equal(@todo3, @list.last)
  end
  
  def test_shift
    assert_equal(@todo1, @list.shift)
    assert_equal(2, @list.size)
  end
  
  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end
  
  def test_done
    assert_equal(false, @list.done?)
  end
  
  def test_shovel
    @todo4 = Todo.new("Hecka")
    @list << @todo4
    @todos << @todo4
    assert_equal(@todos[-1], @todo4)
  end
  
  def test_add
    @todo4 = Todo.new("Hecka2")
    @list.add(@todo4)
    @todos << @todo4
    assert_equal(@todos, @list.to_a)
  end
  
  def test_valid_item_at
    assert_equal(@todos[0], @list.item_at(0))
    assert_raises(IndexError) {@list.item_at(20)}
  end

  def test_mark_done_at
    @list.mark_done_at(0)
    assert_raises(IndexError) {@list.mark_done_at(20)}
    assert(@todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end
  
  def test_mark_undone_at
    @list.mark_undone_at(0)
    @list.mark_done_at(1)
    assert_raises(IndexError) {@list.mark_done_at(20)}
    assert_equal(false, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end
  
  def test_type_error
    assert_raises(TypeError) do
     @list.add("hello")         # this code raises ArgumentError, so this assertion passes
    end
  end
  
  def test_mark_all_done
    @todo1.undone!
    @todo2.undone!
    @todo3.undone!
    @list.mark_all_done
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end
  
  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(100) }
    assert_equal(3, @list.size)
    @list.remove_at(0)
    assert_equal(2, @list.size)
    assert_nil(@list.find_by_title("Buy milk"))
  end
  
  def test_to_s
    output = <<-OUTPUT.chomp.gsub(/^\s+/, "")
     ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
   OUTPUT

    assert_equal(output, @list.to_s)
  end
  
  def test_to_s_one_done
    @todo1.done!
    output = <<-OUTPUT.chomp.gsub(/^\s+/, "")
     ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
   OUTPUT

    assert_equal(output, @list.to_s)
  end
  
   def test_to_s_all_done
    @list.mark_all_done
    output = <<-OUTPUT.chomp.gsub(/^\s+/, "")
     ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
   OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_each
    @todo1.done!
    x = 0
    @list.each {|item| x +=1 if item.done? }
    assert_equal(1, x)
  end
  
   def test_each_return
    x = 0
    return_val = @list.each {|item| x +=1 if item.done? }
    assert_equal(@list, return_val)
  end
  
  def test_select_return
    @todo1.done!
    @todo2.done!
    done_list = @list.select {|todo| todo.done? }
    assert_equal([@todo1, @todo2], done_list.to_a)
  end
  
  def test_find_by_title
    assert_equal(@todo1, @list.find_by_title("Buy milk"))
  end
  
  def test_mark_all_undone
    # first mark them all done
    @list.mark_all_done
    @list.mark_all_undone
    assert_equal(false, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end
  
  def test_mark_done_title
    @todo1.undone!
    @list.mark_done("Buy milk")
    assert_equal(true, @todo1.done?)
  end
  
  def test_all_not_done
  # first mark them all as done
  @list.mark_all_done
  # mark 2 out of the 3 as undone
  @list.mark_undone_at(0)
  @list.mark_undone_at(1)
  assert_equal([@todo1, @todo2], @list.all_not_done.to_a)
  end
  
  def test_select_all_done
    @list.mark_all_undone
    @todo1.done!
    @todo2.done!
    assert_equal([@todo1, @todo2], @list.all_done.to_a)
  end
  
  def test_print
    @list.mark_all_done
    output = <<-OUTPUT.chomp.gsub(/^\s+/, "")
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
   OUTPUT
    assert_output( stdout = output ) { @list.print}
   
  end
  
  
end

#assertions: https://launchschool.com/lessons/dd2ae827/assignments/fe2ff54a
