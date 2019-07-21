
#include "test_helper.hpp"


// https://groups.google.com/forum/#!topic/googletestframework/V_Rek4n8wYE

static std::string MakeHexCompareMessage(const char* header, const char* expectedExpr, const char* actualExpr, uint32_t expected, uint32_t actual)
{
    std::stringstream ss;
    ss.str("");
    ss << "0x" << std::setfill('0') << std::setw(8) << std::hex << expected;
    auto expectedStr = ss.str();
    ss.str("");
    ss << "0x" << std::setfill('0') << std::setw(8) << std::hex << actual;
    auto actualStr = ss.str();

    std::stringstream message;
    message << header << "\n";
    message << "  " << expectedExpr << "\n";
    if (expectedStr != expectedExpr) {
        message << "    Which is: " << expectedStr << "\n";
    }
    message << "  " << actualExpr << "\n";
    if (actualStr != actualExpr) {
        message << "    Which is: " << actualStr << "\n";
    }
    return message.str();
}


testing::AssertionResult CompareHexEq(const char* expectedExpr, const char* actualExpr, uint32_t expected, uint32_t actual)
{
    if (expected == actual) {
        return testing::AssertionSuccess();
    }

    auto message = MakeHexCompareMessage(
        "Expected equality of these values:",
        expectedExpr, actualExpr,
        expected, actual
    );
    return testing::AssertionFailure() << message;
}


testing::AssertionResult CompareHexNe(const char* expectedExpr, const char* actualExpr, uint32_t expected, uint32_t actual)
{
    if (expected != actual) {
        return testing::AssertionSuccess();
    }

    auto message = MakeHexCompareMessage(
        "Expected inequality of these values:",
        expectedExpr, actualExpr,
        expected, actual
    );
    return testing::AssertionFailure() << message;
}
