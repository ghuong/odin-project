require "my-enumerable.rb"

describe Enumerable do

  describe ".my_none?" do
    context "given no block" do
      it "returns false" do
        expect([1,2,3].my_none?).to be false
      end
    end
    
    context "given block that returns true iff negative" do
      let(:proc) { Proc.new { |x| x < 0 } }

      context "with an empty array" do
        it "returns true" do
          expect([].my_none?(&proc)).to be true
        end
      end

      context "with an array of integers" do
        context "where all are positive" do
          it "returns true" do
            expect([1,2,3].my_none?(&proc)).to be true
          end
        end

        context "where one, but not all, are negative" do
          it "return false" do
            expect([1,-2,3].my_none?(&proc)).to be false
          end
        end

        context "and also a string element" do
          it "raises ArgumentError" do
            expect{ [1,"a",3].my_none?(&proc) }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end