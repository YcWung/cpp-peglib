# project(pl0)

include_directories(..)

add_executable(pl0 pl0.cc)
find_package(LLVM REQUIRED CONFIG)
set(add_link_deps ${add_link_deps} LLVM::LLVM)
# target_include_directories(pl0 PUBLIC ${LLVM_INCLUDE_DIRS})
target_link_libraries(pl0 PRIVATE ${add_link_deps})
