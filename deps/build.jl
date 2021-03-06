using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libgeos_c"], :libgeos),
    LibraryProduct(prefix, ["libgeos"], :libgeos_cpp),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaGeo/GEOSBuilder/releases/download/v3.7.2-0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.aarch64-linux-gnu-gcc4.tar.gz", "5787a09eb5f1de0e8328b3fdb482e4cc798fd6b5a4689111f9a6befe15bdbb80"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.aarch64-linux-gnu-gcc7.tar.gz", "9b5ee2b297b10b296ea9c931a83bc3f299352e30a9ff696f0f8d402b3651f403"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.aarch64-linux-gnu-gcc8.tar.gz", "e48d44177d7b5a836860f04959878365a941ace156cfff06e718c37fd55b9c49"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.aarch64-linux-musl-gcc4.tar.gz", "90aec29158928a43a4e2bba4c3116a2d3fc5cc621c829146865d66a6c3cd888a"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.aarch64-linux-musl-gcc7.tar.gz", "7c57861224750ecd3d068a7d7d7e89b1171f4ba49cde4c6762c735b5520fc0cc"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.aarch64-linux-musl-gcc8.tar.gz", "0163dc3893c8ec3befae6227a564c0f26d4db15aab23783c17d70698aa78f29e"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.arm-linux-gnueabihf-gcc4.tar.gz", "99a6816b5503d173ef7c4b9ed1645abb1dabd91a8a7e051a7900e671ac7b62c6"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.arm-linux-gnueabihf-gcc7.tar.gz", "c0d893dd8ddc8fffed1979525eda0ad673f1a2db3cadbd1a05f14a20a8174ed6"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.arm-linux-gnueabihf-gcc8.tar.gz", "e752016544692fa174f157fe63069479888a871f88926a87345b8fb13c48400d"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.arm-linux-musleabihf-gcc4.tar.gz", "af0b3d62984c8bac1f0842124c6ac53a3476c963bdf1219c61215a326d60e7f1"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.arm-linux-musleabihf-gcc7.tar.gz", "6690373e7fc7963ea2c3edbe893001f0856dac27bfcf0550f087116ddaaf7668"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.arm-linux-musleabihf-gcc8.tar.gz", "fccda9b71fab947cefe9c900d383e15e7c4c08331b218a26fa5073b9b12f79ac"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.i686-linux-gnu-gcc4.tar.gz", "4e0b9390d289ca68be601e70a588949602025a459a95479dda35f63c3f29cc3d"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.i686-linux-gnu-gcc7.tar.gz", "82a71e47c60e6c25472519b1a09ef4aa6318a8bed9791f00d492507431e078f9"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.i686-linux-gnu-gcc8.tar.gz", "6d8a73c951dc7e30ebd2f9b8597eeb427f758a2e16854fe58fedcd8b3c2bb1e3"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.i686-linux-musl-gcc4.tar.gz", "aa03493edf4e4913da3d2b32b9237283f5fdc26e35b750deddfa2581f857e140"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.i686-linux-musl-gcc7.tar.gz", "d10d2f8ba7728d45291848c6d7377cf02110b65472580cc372230007f04a82e1"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.i686-linux-musl-gcc8.tar.gz", "ba1d6f8baabe5711f2e69c5076eeb6044595e6f6207524cd7542b23ca7ffa226"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.i686-w64-mingw32-gcc4.tar.gz", "dd98e9fc7fab8b8424f833731f06c40cacb43f1f3ba7036e1e3f79d8027a3453"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.i686-w64-mingw32-gcc7.tar.gz", "165770dbc66573d7a8e10030f7b8547107662cdd8cb7872b63db25d0e32de88c"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.i686-w64-mingw32-gcc8.tar.gz", "a01d8761434684c1f9123f4543467f0ad2d9920a9e659f80d6e5c9c6ddaffa79"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.powerpc64le-linux-gnu-gcc4.tar.gz", "d2121b5fde6163d8cd6b45fb00bd656196629b3dd1d7743634e66ed3b021b7a5"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.powerpc64le-linux-gnu-gcc7.tar.gz", "488df95ca419bbc527ef75a05a7d99a309c86304a42c0ed2313848d0ad2da843"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.powerpc64le-linux-gnu-gcc8.tar.gz", "7ad7f4efa44d0106f36b2cbe9be1fdd6a0ee7133700bc7bd3067d908649484ef"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-apple-darwin14-gcc4.tar.gz", "46d2873ffef747e278af36c429bd14c46ee133aeb454e1d34d4a4915c321ab12"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-apple-darwin14-gcc7.tar.gz", "e8aebc603654e84d4c3327b21273146b897bfd1694411316c31cd345ebf7ee4d"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-apple-darwin14-gcc8.tar.gz", "8f154d5c5422a7d39e5a5da0dad2f35b7669e0b49683e7fe0604b75f4203bba3"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-linux-gnu-gcc4.tar.gz", "be0fd5b0ca50092b27d64be31140871c68898ac635b59fffa3c192c78dab5034"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-linux-gnu-gcc7.tar.gz", "d98b1f02d3d9591630207d75bf12242a80b98b28a2eb2dfe080c396fc8291040"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-linux-gnu-gcc8.tar.gz", "19a4159ee0eb19dd71fc1ab2cd671083846cb6a33a355d9e850d1ebfad7be5f2"),
    # removed compiler_abi as suggested in https://github.com/JuliaPackaging/BinaryBuilder.jl/issues/407#issuecomment-473688254
    # such that GCC4 platforms will also pick up this GCC7 build, ref https://github.com/JuliaPackaging/BinaryBuilder.jl/issues/387
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/GEOS.v3.7.2.x86_64-linux-musl-gcc7.tar.gz", "1032d637fad87e201da9b8418f15dac2d6c4d905bc98ec041cebef718d52bc93"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-linux-musl-gcc8.tar.gz", "bf98e8f95b95d531e6b0a4a6f2ead3d3c07192bdc9c4f6c5adc436b41f1d9177"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-unknown-freebsd11.1-gcc4.tar.gz", "a1b35b13701604012b5f783d0187408d3dfe9825bb5a50815017da9556dc07c1"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-unknown-freebsd11.1-gcc7.tar.gz", "efc48c1a34a38718dcc70ac860ce88ca0ae2ec71b5139d614f19eee602b4f827"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-unknown-freebsd11.1-gcc8.tar.gz", "aaf02142353c250c531625f943f2a11cf52983c6f0a5ae24a2cd5251d8a13bed"),
    # removed compiler_abi as suggested in https://github.com/JuliaPackaging/BinaryBuilder.jl/issues/407#issuecomment-473688254
    # such that GCC4 platforms will also pick up this GCC7 build, ref https://github.com/JuliaPackaging/BinaryBuilder.jl/issues/407
    Windows(:x86_64) => ("$bin_prefix/GEOS.v3.7.2.x86_64-w64-mingw32-gcc7.tar.gz", "34ca72de29b79d9635fceed8764ec6428aa5c92f5ef4158fe70539b500db42c1"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GEOS.v3.7.2.x86_64-w64-mingw32-gcc8.tar.gz", "e571095938420ec3422fc791040fc1970be5659cb54ab5b151bd81ef3d9c0077"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    # ignore_platform is set to true to allow installing the GCC7 builds on GCC4
    # platforms, because of issues with x86_64-linux-musl-gcc4 and x86_64-w64-mingw32-gcc4
    install(dl_info...; prefix=prefix, force=true, verbose=verbose, ignore_platform=true)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
