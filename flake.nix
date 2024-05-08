{
  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    llvmVersion = "18";
    llvmPackages = pkgs."llvmPackages_${llvmVersion}";
    stdenv = llvmPackages.stdenv;

    # points to a local build of llvm with:
    # - -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind"
    # - the #if __has_include(<...>) commented out in $build/modules/c++/v1/std{,.compat}.cppm
    #   (think this is because it's still somehow picking up the system includes from libstdc++? not sure)
    libcxx_build = "/home/bryce/.llvm/build";
  in {
    devShells.${system}.default = pkgs.mkShell.override {inherit stdenv;} {
      packages = with pkgs; [
        cmake
        ninja
        just
        pkgs."clang-tools_${llvmVersion}"
        llvmPackages.libllvm
      ];

      LIBCXX_BUILD = libcxx_build;
      CXXFLAGS = "-nostdinc++ -I${libcxx_build}/include/c++/v1";
      LDFLAGS = "-L${libcxx_build}/lib -Wl,-rpath,${libcxx_build}/lib";
      CMAKE_GENERATOR = "Ninja";
      CMAKE_EXPORT_COMPILE_COMMANDS = true;
    };
  };
}
