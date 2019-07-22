
add_executable(simulator
    "main.cpp"
)

target_link_libraries(simulator
    Vcpu

    # gtest
    # gtest_main
)

target_compile_options(simulator PRIVATE
    -Wall
    -Wextra
    -Werror
    -fdiagnostics-color
)
