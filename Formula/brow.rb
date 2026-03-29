class Brow < Formula
  include Language::Python::Virtualenv

  desc "Standalone Playwright CLI for agent browser automation"
  homepage "https://github.com/detrin/brow"
  url "https://files.pythonhosted.org/packages/05/6f/ef52f5d46dd3ec5b9c84125346c87e30ca143e60286e594b9f1803090eec/brow_cli-1.0.3.tar.gz"
  sha256 "bf46a396f521405ab1c5b0357b746d68a15a5544ce7431122dcc11e27ada77ab"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv with pip (unlike virtualenv_install_with_resources)
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", libexec
    # Install brow-cli with all dependencies from wheels
    system libexec/"bin/pip", "install", "--quiet", "brow-cli==1.0.3"
    # Create symlinks in bin
    bin.install_symlink libexec/"bin/brow"
    bin.install_symlink libexec/"bin/playwright"
  end

  def caveats
    <<~EOS
      Before using brow, install Chromium with:
        playwright install chromium

      Or let it install automatically on first run.
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/brow --help")
  end
end
