BOARD_DIMENSIONS = 8

def knight_moves(start, destination, use_bfs = true)
  paths = []
  paths.push([start])
  path = nil

  while not paths.empty?
    path = use_bfs ? paths.shift : paths.pop

    break if path.last == destination

    moves = get_legal_moves(path.last)
    moves.each do |move|
      paths.push(path + [move]) if not path.include? move
    end
  end

  puts "You made it in " + (path.length-1).to_s + " moves! Here's your path:"
  path.each { |step| puts "[#{step[0]},#{step[1]}]" }
  return path
end

def get_legal_moves(pos)
  moves = [
    [pos[0]+1, pos[1]+2],
    [pos[0]+1, pos[1]-2],
    [pos[0]+2, pos[1]+1],
    [pos[0]+2, pos[1]-1],
    [pos[0]-1, pos[1]+2],
    [pos[0]-1, pos[1]-2],
    [pos[0]-2, pos[1]+1],
    [pos[0]-2, pos[1]-1]
  ].select do |element|
    (0...BOARD_DIMENSIONS).cover?(element[0]) and
      (0...BOARD_DIMENSIONS).cover?(element[1])
  end
end