require "caesar-cipher"

describe "caesar_cipher" do
  context "given an empty cleartext" do
    it { expect{ caesar_cipher("", 3) }.to output("\n").to_stdout }
  end

  context "given cleartext 'abc! xyz! ABC! XYZ!'" do
    let(:cleartext) { "abc! xyz! ABC! XYZ!" }

    context "with shift of 1" do
      it { expect{ caesar_cipher(cleartext, 1) }.to output("bcd! yza! BCD! YZA!\n").to_stdout }
    end

    context "with shift of 2" do
      it { expect{ caesar_cipher(cleartext, 2) }.to output("cde! zab! CDE! ZAB!\n").to_stdout }
    end

    context "with shift of -1" do
      it { expect{ caesar_cipher(cleartext, -1) }.to output("zab! wxy! ZAB! WXY!\n").to_stdout }
    end

    context "with shift of -2" do
      it { expect{ caesar_cipher(cleartext, -2) }.to output("yza! vwx! YZA! VWX!\n").to_stdout }
    end

    context "with shift of 0" do
      it { expect{ caesar_cipher(cleartext, 0) }.to output(cleartext + "\n").to_stdout }
    end

    context "with shift of 26" do
      it { expect{ caesar_cipher(cleartext, 26) }.to output(cleartext + "\n").to_stdout }
    end

    context "with shift of -26" do
      it { expect{ caesar_cipher(cleartext, -26) }.to output(cleartext + "\n").to_stdout }
    end
  end
end