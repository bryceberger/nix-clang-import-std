cmake_minimum_required(VERSION 3.28.0 FATAL_ERROR)
project("example"
  LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS OFF)

include(FetchContent)
FetchContent_Declare(
  std
  URL "file://$ENV{LIBCXX_BUILD}/modules/c++/v1/"
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  SYSTEM
)
FetchContent_MakeAvailable(std)

add_library(foo)
target_link_libraries(foo
  std
)
target_sources(foo
  PUBLIC FILE_SET CXX_MODULES FILES
    src/foo.cpp
    src/foo/impl.cpp
)

add_executable(example)
target_link_libraries(example
  std
  foo
)
target_sources(example
  PRIVATE
    src/main.cpp
)
