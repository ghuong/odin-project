require "controllers/umpire_states/umpire_context"
require "controllers/umpire_states/intro_state"
require "controllers/umpire_states/load_state"
require "controllers/umpire_states/play_state"
require "controllers/umpire_states/save_state"
require "models/chess_game"

describe UmpireContext do

  context 'upon initializing' do
    it 'is in Intro state' do
      expect(subject.get_state).to be_a IntroState
    end

    describe "#process_input" do
      context "given command 'quit'" do
        it 'returns "quit"' do
          expect(subject.process_input("quit")).to eql("quit")
        end
      end

      context "given command 'new'" do
        let(:id) { 12 }
        before { allow(GameSaver).to receive(:get_unique_id) { id } }

        before do
          subject.process_input("new")
          @current_state = subject.get_state
          @current_game = @current_state.get_game
        end

        it 'transitions to PlayState' do
          expect(subject.get_state).to be_a PlayState
        end

        it 'has a unique id' do
          expect(@current_game.id).to eql(id)
        end

        context "given command 'quit'" do
          before { subject.process_input("quit") }
          it 'transitions to Intro state' do
            expect(subject.get_state).to be_a IntroState
          end
        end

        context "given command 'save'" do
          before { subject.process_input("save") }
          it 'transitions to Save state' do
            expect(subject.get_state).to be_a SaveState
          end

          context "given title 'My Game Title'" do
            let(:game_title) { "My Game Title" }
            before { allow(GameSaver).to receive(:save_game) }
            it 'saves the game with given title' do
              expect(GameSaver).to receive(:save_game).with(id, game_title, @current_game)
              subject.process_input(game_title)
            end

            it 'transitions back to the same Play state' do
              subject.process_input(game_title)
              expect(subject.get_state).to equal(@current_state)
            end
          end
        end
      end

      context "given command 'load'" do
        context "when there are some saved games" do
          before do
            allow(UmpireHelpers).to receive(:exist_any_saves?) { true }
            subject.process_input("load")
          end
          it 'transitions to Load state' do
            expect(subject.get_state).to be_a LoadState
          end

          context "given command 'back'" do
            before { subject.process_input("back") }
            it 'transitions to Intro state' do
              expect(subject.get_state).to be_a IntroState
            end
          end

          context "given a valid 'id'" do
            let(:id) { 6 }
            let(:user_input) { "6" }
            let(:loaded_game) { ChessGame.new(6) }
            before { allow(GameSaver).to receive(:load_game_by_id) { loaded_game } }
            it 'transitions to Play state' do
              subject.process_input(user_input)
              expect(subject.get_state).to be_a PlayState
            end

            it 'loads the game' do
              expect(GameSaver).to receive(:load_game_by_id).with(id)
              subject.process_input(user_input)
            end

            it 'has id 6' do
              subject.process_input(user_input)
              expect(subject.get_state.get_game.id).to eql(id)
            end
          end

          context 'given an invalid id' do
            let(:user_input) { "blahblah" }
            before do
              allow(GameSaver).to receive(:load_game_by_id) { nil }
              @load_state = subject.get_state
            end

            it 'remains on same state' do
              subject.process_input(user_input)
              expect(subject.get_state).to eql(@load_state)
            end
          end
        end
      end
    end
  end
end
