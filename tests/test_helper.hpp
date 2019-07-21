
#ifndef TEST_HELPER_HPP
#define TEST_HELPER_HPP

#include <stdint.h>
#include <gtest/gtest.h>


testing::AssertionResult CompareHexEq(const char* expectedExpr, const char* actualExpr, uint32_t expected, uint32_t actual);
testing::AssertionResult CompareHexNe(const char* expectedExpr, const char* actualExpr, uint32_t expected, uint32_t actual);

#define EXPECT_EQ_HEX(expected, actual)  EXPECT_PRED_FORMAT2(CompareHexEq, expected, actual)
#define EXPECT_NE_HEX(expected, actual)  EXPECT_PRED_FORMAT2(CompareHexNe, expected, actual)
#define ASSERT_EQ_HEX(expected, actual)  ASSERT_PRED_FORMAT2(CompareHexEq, expected, actual)
#define ASSERT_NE_HEX(expected, actual)  ASSERT_PRED_FORMAT2(CompareHexNe, expected, actual)


#endif
