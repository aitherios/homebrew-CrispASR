class Crispasr < Formula
  desc "C++ ggml runtime for multilingual ASR and TTS"
  homepage "https://github.com/CrispStrobe/CrispASR"
  license "MIT"
  version "0.8.32"

  on_macos do
    url "https://github.com/CrispStrobe/CrispASR/releases/download/v0.8.32/crispasr-macos.tar.gz"
    sha256 "5e740d35e91a8dcaa79efd3ef0be3412de4796b68066921a9ea6984d2fc6b2ad"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/CrispStrobe/CrispASR/releases/download/v0.8.32/crispasr-linux-arm64.tar.gz"
      sha256 "eb39ca1274084add172764ce638a600e50fc4b65f4b18776aa78dcf31486570c"
    else
      url "https://github.com/CrispStrobe/CrispASR/releases/download/v0.8.32/crispasr-linux-x86_64-cpu-legacy.tar.gz"
      sha256 "039ee3523cd1293e86e29f6395829ac4509e23733631d84f909735f34e227e48"
    end
  end

  def install
    bin.install "crispasr"
    bin.install "crispasr-quantize"

    on_macos do
      lib.install "libc2pa_c.dylib"

      # Fix the dynamic library path so crispasr finds libc2pa_c in the Homebrew lib dir
      MachO::Tools.change_install_name(
        "#{bin}/crispasr",
        "@rpath/libc2pa_c.dylib",
        "#{lib}/libc2pa_c.dylib",
      )

      # Re-sign binaries to clear com.apple.provenance (macOS 14+)
      system "codesign", "--force", "--sign", "-", "#{bin}/crispasr"
      system "codesign", "--force", "--sign", "-", "#{bin}/crispasr-quantize"
      system "codesign", "--force", "--sign", "-", "#{lib}/libc2pa_c.dylib"
    end

    on_linux do
      lib.install "libc2pa_c.so"
      lib.install Dir["lib*.so.*"]
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/crispasr --help 2>&1")
  end
end
