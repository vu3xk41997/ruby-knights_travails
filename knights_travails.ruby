# create board
class GameBoard
    def create_children(parent)
        parent.moves.each do |move|
            child = find_child(move).nil? ? Knight.new(move) : find_child(move)
            parent.children << child
        end
    end

    def create_family_tree(destination, queue = [@alpha], index = 0)
        current = queue[index]
        create_children(current)
        current.children.each do |child|
            next if queue.include?(child)
            queue << child
        end

        return if current == find_child(destination)
        return if index >= 66
        index += 1
        create_family_tree(destination, queue, index)
    end

    def find_child(coordinates, queue = [@alpha], index = 0)
        found_knight = nil
        current = queue[index]
        return if current.nil?
        current.children.each do |child|
            queue << child unless queue.include?(child)
            found_knight = child if child.location == coordinates
        end
        index += 1
        return found_knight unless found_knight.nil?
        find_child(coordinates, queue, index)
    end

    def find_path(destination, path = [destination])
        parent = find_parent(destination)
        path << parent.location
        return path if parent == @alpha
        find_path(parent.location, path)
    end

    def find_parent(destination, queue = [@alpha], index = 0)
        current = queue[index]
        parent = current.moves.any? {|move| move == destination}
        return if current.nil?
        return current if parent == true
        current.children.each do |child|
            queue << child unless queue.include?(child)
        end
        index += 1
        find_parent(destination, queue, index)
    end

    def knight_moves(start, destination)
        @alpha = Knight.new(start)
        create_family_tree(destination)
        path = find_path(destination)
        puts "You made #{path.size - 1} moves, and here's the path:"
        path.each_with_index {|move, index| puts "#{index}: #{move}"}
    end

    private

    def knight_list
        puts "List of all knights:"
        knight_summary = board_locations
        knight_summary.each do |knight|
            current = find_child(knight)
            puts "Location: #{knight}"
            puts "Current #{current} at #{current.location}" unless current.nil?
            puts " "
        end
    end

    def board_locations
        [0, 1, 2, 3, 4, 5, 6, 7].repeated_permitation(2).to_a
    end
end

# create knight
class Knight
    attr_accessor :location, :moves, :children

    def initialize(location)
        @location = location
        @moves = possible_moves(location)
        @children = []
    end

    def possible_moves(location, result = [])
        moves = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
        moves.each do |move|
            x = location[0] + move[0]
            y = location[1] + move[1]
            if x.between?(0, 7) && y.between?(0,7)
                result << [x, y]
            end
        end
        result
    end
end

# main
game = GameBoard.new
game.knight_moves([0,0],[1,2])
puts " "
game.knight_moves([3,3],[4,3])
puts " "
game.knight_moves([3,3],[0,0])
puts " "
