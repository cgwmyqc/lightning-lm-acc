cmake_minimum_required(VERSION 3.16)

project(normal_eq_replay CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(normal_eq_replay normal_eq_replay.cpp)
target_include_directories(normal_eq_replay PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}/../../../src
)

target_compile_options(normal_eq_replay PRIVATE -Wall -Wextra -Wpedantic)
