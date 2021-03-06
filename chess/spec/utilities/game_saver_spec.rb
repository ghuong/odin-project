require "utilities/game_saver"

describe GameSaver do
  describe '#get_save_file_name' do
    context 'given game id 12' do
      it "returns 'saved_games/game_12.yml'" do
        expect(subject.get_save_file_name(12)).to eql("saved_games/game_12.yml")
      end
    end
  end
end