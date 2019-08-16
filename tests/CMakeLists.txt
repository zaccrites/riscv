
add_executable(unit_tests
    "unit_tests/alu_test.cpp"
    "unit_tests/instruction_decode_test.cpp"
    "unit_tests/program_counter_test.cpp"
    "unit_tests/register_file_test.cpp"
    "unit_tests/memory_test.cpp"

    "unit_tests/test_helper.cpp"
)

target_link_libraries(unit_tests
    Valu
    Vinstruction_decode
    Vprogram_counter
    Vregister_file
    Vmemory

    gtest
    gtest_main
)

target_compile_options(unit_tests PRIVATE
    -std=c++14
    -pedantic
    -Wall
    -Wextra
    # -Werror
    -Weffc++
    -Wshadow
    -Wcast-qual
    -Wold-style-cast
    -Wfloat-equal

    -fdiagnostics-color

    -O2
    # -g
)
