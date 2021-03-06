require "models/pieces/queen"
require "models/pieces/shared_examples"

describe Queen do
  it_behaves_like "a rook"
  it_behaves_like "a bishop"
end