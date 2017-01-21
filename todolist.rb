class Todo
  DONE_MARKER = "X"
  UNDONE_MARKER = " "
  
  attr_accessor :title, :description, :done
  
  def initialize (title, description = "")
    @title = title
    @description = description
    @done = false
  end
  
  def done!
    self.done = true
  end
  
  def done?
    done
  end
  
  def undone!
    self.done = false
  end
  
  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end
end

class TodoList
  attr_accessor :title
  
  def initialize(title)
    @title = title
    @todos = []
  end
  
  def add(todo)
    raise TypeError, "You can only add to-do items to this list" unless todo.instance_of? Todo
    @todos << todo
  end
  alias_method :<<, :add

  
  def print
    puts @todos
  end
  
  def size
    @todos.size
  end
  
  def first
    @todos[0]
  end
  
  def last
    @todos[-1]
  end
  
  def item_at(idx)
    @todos.fetch(idx)
  end
  
  def mark_done_at(idx)
    @todos.fetch(idx).done!
  end
  
  def mark_undone_at(idx)
    @todos.fetch(idx).undone!
  end
  
  def shift
    return "no items to remove" if @todos.empty?
    @todos.shift
  end
  
  def pop
    return "no items to pop" if @todos.empty?
    @todos.pop
  end
  
  def remove_at(idx)
    @todos.delete_at(@todos.index(@todos.fetch(idx)))
  end
  
  def to_s
    output = "#{self.title}\n"
    output << "----------------\n"
    output << @todos.map(&:to_s).join("\n")
    output
  end
  
  def each
    0.upto(@todos.size - 1) { |item| yield(@todos[item]) }
    self
  end
  
  def select
    result = TodoList.new("Done List")
    @todos.each do |item|
      result.add(item) if yield(item)
    end
    result
  end
  
  def find_by_title(title)
    select { |todo| todo.title == title }.first
  end
  
  def all_done
    select { |todo| todo.done? }
  end
  
  def all_not_done
    select {|todo| !todo.done? }
  end
  
  def mark_done(title)
    each { |todo| todo.title == title }.first.done!
  end
  
  def mark_all_done
    each { |todo| todo.done! }
  end
  
  def mark_all_undone
    each {|todo| todo.undone!}
  end
  
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")


list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)

list.mark_all_done


puts list














