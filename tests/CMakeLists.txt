
add_executable(instruction_decode_test instruction_decode_test.cpp)
target_link_libraries(instruction_decode_test Vinstruction_decode gtest gtest_main)
target_compile_options(instruction_decode_test PRIVATE -Wall -Wextra)


add_executable(alu_test alu_test.cpp)
target_link_libraries(alu_test Valu gtest gtest_main)
target_compile_options(alu_test PRIVATE -Wall -Wextra -Werror)


add_executable(program_counter_test program_counter_test.cpp)
target_link_libraries(program_counter_test Vprogram_counter gtest gtest_main)
target_compile_options(program_counter_test PRIVATE -Wall -Wextra -Werror)
