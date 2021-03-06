require_relative "binary_tree"

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324].shuffle

tree = build_tree(array)

nodeA = tree.breadth_first_search(23)
nodeB = tree.breadth_first_search(6345)
nodeC = tree.breadth_first_search(0)

print (not nodeA.nil?), ", #{nodeA.value}\n"
print (not nodeB.nil?), ", #{nodeB.value}\n"
puts nodeC.nil?

nodeA = tree.depth_first_search(23)
nodeB = tree.depth_first_search(6345)
nodeC = tree.depth_first_search(0)

print (not nodeA.nil?), ", #{nodeA.value}\n"
print (not nodeB.nil?), ", #{nodeB.value}\n"
puts nodeC.nil?

nodeA = tree.dfs_rec(23)
nodeB = tree.dfs_rec(6345)
nodeC = tree.dfs_rec(0)

print (not nodeA.nil?), ", #{nodeA.value}\n"
print (not nodeB.nil?), ", #{nodeB.value}\n"
puts nodeC.nil?