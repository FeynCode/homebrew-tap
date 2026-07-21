# frozen_string_literal: true

# Tachyon is CLOSED-SOURCE. This formula installs a prebuilt binary — it is
# NEVER compiled from source, so it has no source `url`, `head`, or `bottle`.
#
# This is the TEMPLATE. It lives in this repo for review, but the *live* formula
# belongs in the separate public tap repo github.com/feyncode/homebrew-tap at
# Formula/tachyon.rb. The release CI fills the version and per-arch sha256
# placeholders below and pushes the rendered file there. See README.md here.
class Tachyon < Formula
  desc "Full-fledged terminal coding agent"
  homepage "https://tachyon.feyncode.com"
  version "0.17.1"
  license :cannot_represent # proprietary FeynCode EULA — no SPDX identifier

  depends_on :macos # only darwin assets are published today

  on_macos do
    on_arm do
      url "https://tachyon.feyncode.com/releases/v#{version}/tachyon-darwin-arm64"
      sha256 "7aabcd3bebf49d73f9ad219fa54941ace541bae84d33d09aecaa531a260d206c"
    end
    on_intel do
      url "https://tachyon.feyncode.com/releases/v#{version}/tachyon-darwin-x64"
      sha256 "727eea253c0aa070d3822f7bd7592924a6676616d39d9709b134220ef33a8c90"
    end
  end

  def install
    # A bare (non-archive) download is staged under its remote basename; rename
    # it to `tachyon`. bin.install also sets the executable bit.
    binary = Hardware::CPU.arm? ? "tachyon-darwin-arm64" : "tachyon-darwin-x64"
    bin.install binary => "tachyon"
  end

  def caveats
    <<~EOS
      Tachyon is proprietary software under the FeynCode EULA:
        https://tachyon.feyncode.com/eula

      Authenticate before first use:
        tachyon login
    EOS
  end

  test do
    # Must stay non-interactive — never launch the TUI, or `brew test` hangs.
    assert_match version.to_s, shell_output("#{bin}/tachyon --version")
  end
end
