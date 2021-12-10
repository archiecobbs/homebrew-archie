class Bom < Formula
  desc "Deals with Unicode byte order marks"
  homepage "https://github.com/archiecobbs/bom"
  url "https://github.com/archiecobbs/bom/archive/1.0.1.tar.gz"
  sha256 "28bdf72272df5f862c754e18951732670ac91bc7882f1e03db5fb9b9c528c6a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any_skip_relocation, monterey:       "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any_skip_relocation, big_sur:        "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any_skip_relocation, catalina:       "0000000000000000000000000000000000000000000000000000000000000000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0000000000000000000000000000000000000000000000000000000000000000"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "foo",
                 pipe_output("#{bin}/bom -su\n'", "\xff\xfe\x66\x00\x6f\x00\x6f\x00")
  end
end
