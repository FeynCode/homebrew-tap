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
  version "0.0.87"
  license :cannot_represent # proprietary FeynCode EULA — no SPDX identifier

  depends_on :macos # only darwin assets are published today

  on_macos do
    on_arm do
      url "https://kaeonix.com/releases/v#{version}/kaeonix-darwin-arm64"
      sha256 "e7c4a4bcfcb96246dea1ee30195f986b85b3a14d58b75df2ff462c4b14348872"
    end
    on_intel do
      url "https://kaeonix.com/releases/v#{version}/kaeonix-darwin-x64"
      sha256 "74a4cb741395c0f0ef6bcf056f83ba1e3da3b97ed334d03f84341e54ee1f90d2"
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
