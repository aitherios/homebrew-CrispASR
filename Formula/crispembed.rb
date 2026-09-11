class Crispembed < Formula
  desc "C++ ggml runtime for embeddings, retrieval, OCR, and document understanding"
  homepage "https://github.com/CrispStrobe/CrispEmbed"
  license "MIT"
  version "0.17.10"

  on_macos do
    url "https://github.com/CrispStrobe/CrispEmbed/releases/download/v0.17.10/crispembed-macos-arm64.tar.gz"
    sha256 "f6188e21f7d104c1c649c9e7090484906477f05ec7935d3f32275575c7467ef6"
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/CrispStrobe/CrispEmbed/releases/download/v0.17.10/crispembed-linux-arm64.tar.gz"
      sha256 "00efc064958517afc16f90d7219c5f7d33037e01008b8abed9492de245bdac7c"
    else
      url "https://github.com/CrispStrobe/CrispEmbed/releases/download/v0.17.10/crispembed-linux-x86_64.tar.gz"
      sha256 "dbc6eda8ad5901bd91bb8ed982c158376aa1abed2cfdc93a444f248019894477"
    end
  end

  def install
    bin.install "crispembed"
    bin.install "crispembed-server"
    bin.install "crispembed-quantize"

    on_macos do
      lib.install Dir["*.dylib"]
      include.install Dir["include/*"]

      # Rewrite @rpath references to the Homebrew lib directory
      dylibs = %w[
        libggml.0.dylib
        libggml-base.0.dylib
        libggml-blas.0.dylib
        libggml-cpu.0.dylib
        libggml-metal.0.dylib
        libcrispembed.0.dylib
      ]

      (bin.children + lib.glob("*.dylib")).each do |macho|
        dylibs.each do |dylib|
          MachO::Tools.change_install_name(
            macho.to_s,
            "@rpath/#{dylib}",
            "#{lib}/#{dylib}",
          )
        rescue MachO::MachOError
          # Skip if this dylib isn't referenced by this file
        end
      end

      # Re-sign all binaries and libraries to clear com.apple.provenance
      [*bin.children, *lib.glob("*.dylib")].each do |f|
        system "codesign", "--force", "--sign", "-", f.to_s
      end
    end

    on_linux do
      lib.install Dir["*.so*"]
      include.install Dir["include/*"]
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/crispembed --help 2>&1")
  end
end
