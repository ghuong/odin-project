class LinkedList
  def append(node)
    if not node.is_a? Node then node = Node.new(node) end

    if @tail.nil?
      @tail = node
      @head = @tail
    else
      @tail.next_node = node
      @tail = node
    end
  end

  def prepend(node)
    if not node.is_a? Node then node = Node.new(node) end

    if @head.nil?
      @head = node
      @tail = @head
    else
      node.next_node = @head
      @head = node
    end
  end

  def size
    if @head.nil? then return 0 end

    count = 1
    node = @head
    while not node.next_node.nil?
      count += 1
      node = node.next_node
    end
    return count
  end

  def head
    @head
  end

  def tail
    @tail
  end

  def at(index)
    if index < 0 then raise "Negative Index" end
    if index >= size then raise "Index Out of Bounds" end

    node = @head
    i = 0
    while i < index
      i += 1
      node = node.next_node
    end
    return node
  end

  def pop
    if @tail.nil? then return end

    if @head == @tail
      node = @head
      @head = nil
      @tail = nil
      return node
    else
      node = @head
      while node.next_node != @tail
        node = node.next_node
      end
      old_tail = @tail
      @tail = node
      @tail.next_node = nil
      return old_tail
    end
  end

  def contains?(value)
    node = @head
    while not node.nil?
      if node.value == value then return true end

      node = node.next_node
    end
    return false
  end

  def find(data)
    i = 0
    node = @head
    while not node.nil?
      if node.value == data then return i end

      i += 1
      node = node.next_node
    end
    return nil
  end

  def to_s
    string = ""
    node = @head
    while not node.nil?
      string += "( #{node.value} ) -> "
      node = node.next_node
    end
    string += "nil"
    return string
  end
end

class Node
  attr_accessor :value, :next_node

  def initialize(value = nil)
    @value = value
    @next_node = nil
  end
end