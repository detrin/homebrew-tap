class Brow < Formula
  include Language::Python::Virtualenv

  desc "Standalone Playwright CLI for agent browser automation"
  homepage "https://github.com/detrin/brow"
  url "https://files.pythonhosted.org/packages/a3/d1/dacda6a1aea857531aa33d00a336b39b79107ea59501f62a20f9cd6b42ed/brow_cli-1.0.2.tar.gz"
  sha256 "6d0c56c4e13f8dab68f0c6d4440ca73f8ac2359b02485330d4c27945b15472e1"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv with pip (unlike virtualenv_install_with_resources)
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", libexec
    # Install brow-cli with all dependencies from wheels
    system libexec/"bin/pip", "install", "--quiet", "brow-cli==1.0.2"
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
