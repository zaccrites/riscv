
cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

project(riscv VERSION 0.1.0
              DESCRIPTION "RISC-V CPU Core"
              LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
include(googletest)

add_subdirectory(tests)
add_subdirectory(Vmodules)
