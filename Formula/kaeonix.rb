# frozen_string_literal: true

# Kaeonix is CLOSED-SOURCE. This formula installs a prebuilt binary — it is
# NEVER compiled from source, so it has no source `url`, `head`, or `bottle`.
#
# This is the TEMPLATE. It lives in this repo for review, but the *live* formula
# belongs in the separate public tap repo github.com/feyncode/homebrew-tap at
# Formula/kaeonix.rb. The release CI fills the version and per-arch sha256
# placeholders below and pushes the rendered file there. See README.md here.
class Kaeonix < Formula
  desc "Full-fledged terminal coding agent"
  homepage "https://kaeonix.com"
  version "0.0.24"
  license :cannot_represent # proprietary FeynCode EULA — no SPDX identifier

  depends_on :macos # only darwin assets are published today

  on_macos do
    on_arm do
      url "https://kaeonix.com/releases/v#{version}/kaeonix-darwin-arm64"
      sha256 "c85cd558c557fe10d42537ca628727fc667216d301a39c4e9e6a8dea7f8f3b6c"
    end
    on_intel do
      url "https://kaeonix.com/releases/v#{version}/kaeonix-darwin-x64"
      sha256 "dcae3263ad4a06db01556dcb7154ce449fa27d89efd028b9c22ea1926cdf4f8a"
    end
  end

  def install
    # A bare (non-archive) download is staged under its remote basename; rename
    # it to `kaeonix`. bin.install also sets the executable bit.
    binary = Hardware::CPU.arm? ? "kaeonix-darwin-arm64" : "kaeonix-darwin-x64"
    bin.install binary => "kaeonix"
    # `kx` is the short alias; a relative symlink so upgrades move both.
    bin.install_symlink "kaeonix" => "kx"
  end

  def caveats
    <<~EOS
      Kaeonix is proprietary software under the FeynCode EULA:
        https://kaeonix.com/eula

      Authenticate before first use:
        kx login
    EOS
  end

  test do
    # Must stay non-interactive — never launch the TUI, or `brew test` hangs.
    assert_match version.to_s, shell_output("#{bin}/kaeonix --version")
  end
end
