from conans import ConanFile, CMake

class PeglibConanFile(ConanFile):
    name = "cpp-peglib"
    version = "0.0.1"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": True, "fPIC": True}
    generators = "cmake_find_package_multi"

    def requirements(self):
        self.requires("llvm-core/13.0.0", private=True)
        self.requires("gtest/1.11.0", private=True)

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC
