require "connect_four"

describe ConnectFour do
  context 'before any moves' do
    it 'is empty' do
      subject.columns.each do |column|
        expect(column.length).to eql(0)
      end
    end
  end

  describe '#move' do
    context 'after first valid move' do
      let!(:first_player) { subject.get_current_player }
      let!(:column_before_move) do
        Marshal.load Marshal::dump(subject.columns[column_index])
      end

      let(:column_index) { 2 }
      let(:column) { subject.columns[column_index] }

      before { subject.move(column_index) }
      
      it 'is no longer first player\'s turn' do
        expect(subject.get_current_player).not_to eql(first_player)
      end

      it 'means that column contains one piece' do
        expect(column.length).to eql(1)
      end

      it 'means top of that column is first player\'s piece' do
        expect(column.last).to eql(first_player)
      end

      context 'and after second valid move in the same column' do
        let!(:second_player) { subject.get_current_player }

        before { subject.move(column_index) }

        it 'is first player\'s turn again' do
          expect(subject.get_current_player).to eql(first_player)
        end

        it 'means that column contains two pieces' do
          expect(column.length).to eql(2)
        end

        it 'means top of that column is second player\'s piece' do
          expect(column.last).to eql(second_player)
        end
      end
    end

    context 'when column index is negative' do
      it 'returns false' do
        expect(subject.move(-1)).to be false
      end
    end

    context 'when column index out of bounds' do
      it 'returns false' do
        expect(subject.move(ConnectFour::NUM_COLS)).to be false
      end
    end

    context 'when column is full' do
      before { ConnectFour::MAX_HEIGHT.times { subject.move(0) } }

      it 'returns false' do
        expect(subject.move(0)).to be false
      end
    end
  end

  describe "#connect_four?" do
    context 'when empty' do
      it 'returns false' do
        subject.columns.each_with_index do |column, column_index|
          expect(subject.connect_four?(column_index)).to be false
        end
      end
    end

    context "when only three-of-a-kind in a column" do
      let(:column_index) { 5 }

      before do
        3.times do |i|
          subject.move(i)
          subject.move(column_index)
        end
      end

      it 'returns false' do
        expect(subject.connect_four?(column_index)).to be false
      end
    end

    context 'when four-of-a-kind in a column' do
      let(:column_index) { 5 }

      before do
        4.times do |i|
          subject.move(i)
          subject.move(column_index)
        end
      end

      it 'returns true' do
        expect(subject.connect_four?(column_index)).to be true
      end
    end

    context 'when five-of-a-kind in a column' do
      let(:column_index) { 5 }

      before do
        5.times do |i|
          subject.move(i)
          subject.move(column_index)
        end
      end

      it 'returns true' do
        expect(subject.connect_four?(column_index)).to be true
      end
    end

    context 'when column is blocked' do
      let(:column_index) { 5 }

      before do
        subject.move(column_index) # P1
        subject.move(column_index) # P2
        3.times do |i|
          subject.move(column_index) # P1
          subject.move(i) # P2
        end
      end

      it 'returns false' do
        expect(subject.connect_four?(column_index)).to be false
      end
    end

    context "when three-of-a-kind in a row" do
      before do
        3.times do |i|
          subject.move(i + 1)
          subject.move(0)
        end
      end

      it 'returns false' do
        expect(subject.connect_four?(2)).to be false  
      end
    end

    context "when four-of-a-kind in a row" do
      before do
        4.times do |i|
          subject.move(i + 1)
          subject.move(0)
        end
      end

      it 'returns true' do
        expect(subject.connect_four?(2)).to be true  
      end
    end

    context "when five-of-a-kind in a row" do
      before do
        5.times do |i|
          subject.move(i + 1)
          subject.move(0)
        end
      end

      it 'returns true' do
        expect(subject.connect_four?(3)).to be true  
      end
    end

    context "when row is incomplete or blocked" do
      before do
        subject.move(0) # P1
        subject.move(1) # P2
        subject.move(2) # P1
        subject.move(1) # P2
        subject.move(3) # P1
        subject.move(1) # P2
        subject.move(4) # P1
        subject.move(1) # P2
        subject.move(6) # P1
      end

      it 'returns false' do
        expect(subject.connect_four?(3)).to be false  
      end
    end

    context "when three-of-a-kind in a downwards diagonal" do
      before do
        # column 4
        subject.move(4) # P1, first in diagonal
        # column 3
        subject.move(3) # P2, col 3 has 1
        subject.move(3) # P1, second in diagonal
        # column 2
        subject.move(2) # P2, col 2 has 1
        subject.move(2) # P1, col 2 has 2
        subject.move(1) # P2, col 1 has 1
        subject.move(2) # P1, third in diagonal
      end

      it 'returns false' do
        expect(subject.connect_four?(3)).to be false  
      end
    end

    context "when four-of-a-kind in a downwards diagonal" do
      before do
        # column 4
        subject.move(4) # P1, first in diagonal
        # column 3
        subject.move(3) # P2, col 3 has 1
        subject.move(3) # P1, second in diagonal
        # column 2
        subject.move(2) # P2, col 2 has 1
        subject.move(2) # P1, col 2 has 2
        subject.move(1) # P2, col 1 has 1
        subject.move(2) # P1, third in diagonal
        # column 1
        subject.move(1) # P2, col 1 has 2
        subject.move(1) # P1, col 1 has 3
        subject.move(0) # P2, col 0 has 1
        subject.move(1) # P1, fourth in diagonal
      end

      it 'returns true' do
        expect(subject.connect_four?(3)).to be true  
      end
    end

    context "when five-of-a-kind in a downwards diagonal" do
      before do
        # column 4
        subject.move(4) # P1, first in diagonal
        # column 3
        subject.move(3) # P2, col 3 has 1
        subject.move(3) # P1, second in diagonal
        # column 2
        subject.move(2) # P2, col 2 has 1
        subject.move(2) # P1, col 2 has 2
        subject.move(1) # P2, col 1 has 1
        subject.move(2) # P1, third in diagonal
        # column 1
        subject.move(1) # P2, col 1 has 2
        subject.move(1) # P1, col 1 has 3
        subject.move(0) # P2, col 0 has 1
        subject.move(1) # P1, fourth in diagonal
        # column 0
        subject.move(0) # P2, col 0 has 2
        subject.move(0) # P1, col 0 has 3
        subject.move(0) # P2, col 0 has 4
        subject.move(0) # P1, fifth in diagonal
      end

      it 'returns true' do
        expect(subject.connect_four?(2)).to be true  
      end
    end

    context "when downwards diagonal is blocked" do
      before do
        # column 4
        subject.move(4) # P1, first in diagonal
        # column 3
        subject.move(3) # P2, col 3 has 1
        subject.move(3) # P1, second in diagonal
        # column 2
        subject.move(2) # P2, col 2 has 1
        subject.move(2) # P1, col 2 has 2
        subject.move(1) # P2, col 1 has 1
        subject.move(2) # P1, third in diagonal
        # column 1
        subject.move(1) # P2, col 1 has 2
        subject.move(1) # P1, col 1 has 3
        subject.move(1) # P2, col 1 BLOCKED!
        # column 0
        subject.move(0) # P1, col 0 has 1
        subject.move(0) # P2, col 0 has 2
        subject.move(0) # P1, col 0 has 3
        subject.move(0) # P2, col 0 has 4
        subject.move(0) # P1
      end

      it 'returns false' do
        expect(subject.connect_four?(2)).to be false  
      end
    end

    context "when three-of-a-kind in an upwards diagonal" do
      before do
        # column 0
        subject.move(0) # P1, first in diagonal
        # column 1
        subject.move(1) # P2, col 1 has 1
        subject.move(1) # P1, second in diagonal
        # column 2
        subject.move(2) # P2, col 2 has 1
        subject.move(2) # P1, col 2 has 2
        subject.move(3) # P2, col 3 has 1
        subject.move(2) # P1, third in diagonal
      end

      it 'returns false' do
        expect(subject.connect_four?(1)).to be false  
      end
    end

    context "when four-of-a-kind in an upwards diagonal" do
      before do
        # column 0
        subject.move(0) # P1, first in diagonal
        # column 1
        subject.move(1) # P2, col 1 has 1
        subject.move(1) # P1, second in diagonal
        # column 2
        subject.move(2) # P2, col 2 has 1
        subject.move(2) # P1, col 2 has 2
        subject.move(3) # P2, col 3 has 1
        subject.move(2) # P1, third in diagonal
        # column 3
        subject.move(3) # P2, col 3 has 2
        subject.move(3) # P1, col 3 has 3
        subject.move(4) # P2, col 4 has 1
        subject.move(3) # P1, fourth in diagonal
      end

      it 'returns true' do
        expect(subject.connect_four?(2)).to be true  
      end
    end

    context "when five-of-a-kind in an upwards diagonal" do
      before do
        # column 0
        subject.move(0) # P1, first in diagonal
        # column 1
        subject.move(1) # P2, col 1 has 1
        subject.move(1) # P1, second in diagonal
        # column 2
        subject.move(2) # P2, col 2 has 1
        subject.move(2) # P1, col 2 has 2
        subject.move(3) # P2, col 3 has 1
        subject.move(2) # P1, third in diagonal
        # column 3
        subject.move(3) # P2, col 3 has 2
        subject.move(3) # P1, col 3 has 3
        subject.move(4) # P2, col 4 has 1
        subject.move(3) # P1, fourth in diagonal
        # column 4
        subject.move(4) # P2, col 4 has 2
        subject.move(4) # P1, col 4 has 3
        subject.move(4) # P2, col 4 has 4
        subject.move(4) # P1, fifth in diagonal
      end

      it 'returns true' do
        expect(subject.connect_four?(2)).to be true  
      end
    end

    context "when upwards diagonal is incomplete" do
      before do
        # column 0
        subject.move(0) # P1, first in diagonal
        # column 1
        subject.move(1) # P2, col 1 has 1
        subject.move(1) # P1, second in diagonal
        # column 2
        subject.move(2) # P2, col 2 has 1
        subject.move(2) # P1, col 2 has 2
        subject.move(3) # P2, col 3 has 1
        subject.move(2) # P1, third in diagonal
        # column 3
        subject.move(3) # P2, col 3 has 2
        subject.move(3) # P1, col 3 has 3
        subject.move(3) # P2, col 3 BLOCKED
        # column 4
        subject.move(4) # P1, col 4 has 1
        subject.move(4) # P2, col 4 has 2
        subject.move(4) # P1, col 4 has 3
        subject.move(4) # P2, col 4 has 4
        subject.move(4) # P1
      end

      it 'returns false' do
        expect(subject.connect_four?(2)).to be false  
      end
    end
  end
end