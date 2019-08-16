
add_executable(simulator
    "main.cpp"
)

target_link_libraries(simulator
    Vcpu

    # gtest
    # gtest_main
)


# TODO: Prevent copy-paste of compiler settings to unit_test target
target_compile_options(simulator PRIVATE
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
