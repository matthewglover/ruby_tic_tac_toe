class MiniMax

  DRAWING_SCORE = OUT_OF_DEPTH_SCORE = 0

  attr_reader :move, :score

  def initialize(initial_board, depth: 0, is_maximising: true, max_depth: nil)
    @initial_board = initial_board
    @depth = depth
    @is_maximising = is_maximising
    @max_depth = max_depth.nil? ? max_move_depth : max_depth
  end

  def execute
    @move, @score = move_scores.send(max_or_min_by, &:last)
    self
  end

  private
  def max_move_depth
    @initial_board.total_squares + 1
  end

  def move_scores
    possible_moves.map { |move| [move, move_score(move)] }
  end

  def possible_moves
    @initial_board.empty_squares
  end

  def move_score(move)
    board_score(@initial_board.move(move))
  end

  def board_score(board)
    return final_score(board) if board.complete?
    return out_of_depth_score if out_of_depth?
    return recursive_score(board)
  end

  def final_score(board)
    winning_move(board) ? winning_score : drawing_score
  end

  def winning_move(board)
    board.winner? && next_player_wins?(board)
  end

  def next_player_wins?(board)
    board.winner == @initial_board.next_player
  end

  def winning_score
    (base_winning_score * mini_max_multiplier) - depth_offset
  end

  def base_winning_score
    max_move_depth
  end

  def mini_max_multiplier 
    @is_maximising ? 1 : -1
  end

  def depth_offset
    @is_maximising ? @depth : -@depth
  end

  def drawing_score
    DRAWING_SCORE
  end

  def out_of_depth?
    next_depth == @max_depth
  end

  def next_depth
    @depth + 1
  end

  def out_of_depth_score
    OUT_OF_DEPTH_SCORE
  end

  def recursive_score(board)
    MiniMax.new(board, recursive_options).execute.score
  end

  def recursive_options
    { depth: next_depth, is_maximising: !@is_maximising, max_depth: @max_depth }
  end

  def max_or_min_by
    @is_maximising ? :max_by : :min_by
  end
end
