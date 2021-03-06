class Node
  attr_accessor :value, :parent, :left_child, :right_child

  def initialize(value)
    @value = value
  end

  def breadth_first_search(target)
    queue = []
    queue.push(self)

    while not queue.empty?
      visit = queue.shift

      if visit.value == target then return visit end

      queue.push(visit.left_child) if not visit.left_child.nil?
      queue.push(visit.right_child) if not visit.right_child.nil?
    end
    return nil
  end

  def depth_first_search(target)
    stack = []
    stack.push(self)

    while not stack.empty?
      visit = stack.pop

      if visit.value == target then return visit end

      stack.push(visit.left_child) if not visit.left_child.nil?
      stack.push(visit.right_child) if not visit.right_child.nil?
    end
    return nil
  end

  def dfs_rec(target)
    if not @left_child.nil?
      search_result = @left_child.dfs_rec(target)
      return search_result if not search_result.nil?
    end

    if @value == target then return self end

    if not @right_child.nil?
      search_result = @right_child.dfs_rec(target)
      return search_result if not search_result.nil?
    end

    return nil
  end
end

# build a tree, and return it
def build_tree(array)
  if array.empty? then return nil end

  tree = Node.new(array[0])
  lesser_array = array[1..-1].select { |element| element <= array[0] }
  greater_array = array[1..-1].select { |element| element > array[0] }

  tree.left_child = build_tree(lesser_array)
  tree.left_child.parent = tree if not tree.left_child.nil?
  tree.right_child = build_tree(greater_array)
  tree.right_child.parent = tree if not tree.right_child.nil?

  return tree
end

