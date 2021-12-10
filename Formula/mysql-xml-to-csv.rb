class MysqlXmlToCsv < Formula
  desc "Convert MySQL XML output to CSV"
  homepage "https://github.com/archiecobbs/mysql-xml-to-csv"
  url "https://github.com/archiecobbs/mysql-xml-to-csv/archive/1.0.0.tar.gz"
  sha256 "4be4afe21ec4a23801f9e85161ca8ca8d623a559473af47dcc7e87bd7b723026"
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
    assert_equal "\"foobar\"\n",
                 pipe_output("#{bin}/mysql-xml-to-csv -N", "<resultset><row><field name=\"x\">foobar</field></row></resultset>")
  end
end
