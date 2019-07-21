
add_executable(unit_tests
    alu_test.cpp
    instruction_decode_test.cpp
    program_counter_test.cpp
    register_file_test.cpp
    memory_test.cpp

    test_helper.cpp
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
    -Wall
    -Wextra
    -Werror
    -fdiagnostics-color
)
