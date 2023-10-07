class Sailor < Formula
  desc "Description of your CLI tool"
  homepage "https://github.com/JoshSweaterGuy/Sailor"
#   Choosing not to use a tarbell right now so this will fetch the current version of main
#   url "https://github.com/yourusername/sailor/archive/v1.0.0.tar.gz"
#   sha256 "checksum_of_your_tarball"
  head "https://github.com/JoshSweaterGuy/Sailor", branch: "main"

def install
  libexec.install "sailor" # Install your CLI tool to libexec
  bin.write_exec_script libexec/"sailor" # Create a symlink in bin to your tool
end

  test do
    system "#{bin}/sailor", "--version" # Test your CLI tool
  end
end
