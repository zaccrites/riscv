
#ifndef TEST_HELPER_HPP
#define TEST_HELPER_HPP

#include <stdint.h>
#include <gtest/gtest.h>


// https://groups.google.com/forum/#!topic/googletestframework/V_Rek4n8wYE

testing::AssertionResult CompareAndOutputHex(const char* expectedExpr, const char* actualExpr, uint32_t expected, uint32_t actual)
{
    if (expected == actual) {
        return testing::AssertionSuccess();
    }

    std::stringstream ss;
    ss.str("");
    ss << "0x" << std::setfill('0') << std::setw(8) << std::hex << expected;
    std::string expectedStr = ss.str();
    ss.str("");
    ss << "0x" << std::setfill('0') << std::setw(8) << std::hex << actual;
    std::string actualStr = ss.str();

    std::stringstream message;
    message << "Expected equality of these values:\n";
    message << "  " << expectedExpr << "\n";
    if (expectedStr != expectedExpr) {
        message << "    Which is: " << expectedStr << "\n";
    }
    message << "  " << actualStr << "\n";
    if (actualStr != actualExpr) {
        message << "    Which is: " << actualStr << "\n";
    }

    return testing::AssertionFailure() << message.str();
}


#define EXPECT_EQ_HEX(expected, actual)  \
    EXPECT_PRED_FORMAT2(CompareAndOutputHex, expected, actual)


#endif
