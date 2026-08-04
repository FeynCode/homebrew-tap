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
  version "0.0.21"
  license :cannot_represent # proprietary FeynCode EULA — no SPDX identifier

  depends_on :macos # only darwin assets are published today

  on_macos do
    on_arm do
      url "https://kaeonix.com/releases/v#{version}/kaeonix-darwin-arm64"
      sha256 "c129406d4caf244e0e4e5eeca676dcfcfd71ba37f6f520b2af54ad2db0685603"
    end
    on_intel do
      url "https://kaeonix.com/releases/v#{version}/kaeonix-darwin-x64"
      sha256 "918cef319656618cdf16af42b74f857ab89467aaa4c17b32e3f3bf17b18ba2f4"
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
