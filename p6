/*
Link : https://leetcode.com/problems/minimum-time-to-make-array-sum-at-most-x/description/

Julie is given two 0-indexed integer arrays nums_1 and nums_2 of equal length. Every second, for all indices 0 \leq i < \text{len(nums_1)}, the value of nums_1[i] is incremented by nums_2[i]. 
After this, Julie can perform the following operation:

Choose an index 0 <= i < nums_1.length and make nums_1[i] = 0.

Julie is also given an integer val.

Return an Integer denoting the minimum time in which Julie can make the sum of all elements of nums_1 less than or equal to val, or -1 if this is not possible.

Create a C++ Function MinimumTimeRequired that will return an integer denoting the minimum time, or -1 if this is not possible.

Use appropriate error handling using the stdexcept library for the invalid test cases.

Input Type:

A vector<int> denoting nums_1
A vector<int> denoting nums_2
An integer denoting val

Input Constraints:

The length of nums_1 should be at least 1 and at most 10^3 inclusive.
The length of nums_2 should be at least 1 and at most 10^3 inclusive.
Each value of nums_1[i] should be in the range [1, 10^3] inclusive.
Each value of nums_2[i] should be in the range [0, 10^3] inclusive.
nums_1.length == nums_2.length
val should be in the range [0, 10^6] inclusive.

*/


#include <vector>
#include <algorithm>
#include <stdexcept>
#include <cassert>

    int MinimumTimeRequired(std::vector<int>& nums_1, std::vector<int>& nums_2, int val) {
        int len = nums_1.size();

        if (len < 1 || len > 1000) throw std::invalid_argument("Invalid length of nums_1");
        if (nums_2.size() != len) throw std::invalid_argument("nums_1 and nums_2 must have the same length");
        if (val < 0 || val > 1000000) throw std::invalid_argument("Invalid value for val");
        for (int i = 0; i < len; ++i) {
            if (nums_1[i] < 1 || nums_1[i] > 1000) throw std::invalid_argument("Invalid value in nums_1");
            if (nums_2[i] < 0 || nums_2[i] > 1000) throw std::invalid_argument("Invalid value in nums_2");
        }

        std::vector<std::vector<int>> arr(len, std::vector<int>(2));
        for (int i = 0; i < len; ++i) {
            arr[i][0] = nums_2[i];
            arr[i][1] = nums_1[i];
        }
        std::sort(arr.begin(), arr.end());
        
        int sum_nums = 0, sum_delta = 0;
        for (int i = 0; i < len; ++i) {
            nums_2[i] = arr[i][0];
            nums_1[i] = arr[i][1];
            sum_nums += nums_1[i];
            sum_delta += nums_2[i];
        }
        
        if (sum_nums <= val) return 0;
        
        std::vector<int> dp_table(len, 0);
        int cur_max = 0;
        for (int i = 0; i < len; ++i) {
            cur_max = std::max(cur_max, nums_1[i] + nums_2[i]);
            dp_table[i] = cur_max;
            if (dp_table[i] >= sum_nums + sum_delta - val) return 1;
        }

        int sum = 0;
        for (int i = 2; i <= len; ++i) {
            sum = sum_nums + i * sum_delta;
            
            cur_max = 0;
            std::vector<int> temp_dp_table(len, 0);
            for (int j = i - 1; j < len; ++j) {
                int value = nums_1[j] + i * nums_2[j];
                cur_max = std::max(cur_max, value + dp_table[j - 1]);
                if (cur_max >= sum - val) return i;
                temp_dp_table[j] = cur_max;
            }
            for (int j = 0; j < len; ++j) dp_table[j] = temp_dp_table[j];
        }
        
        return -1;
    }


int main(){
  
  //TEST
std::vector<int> nums_1_1 = {1};
std::vector<int> nums_2_1 = {0};
int val_1 = 1;
int expected_1 = 0;
int result_1 = MinimumTimeRequired(nums_1_1, nums_2_1, val_1);
assert(result_1 == expected_1);
//TEST_END

//TEST
std::vector<int> nums_1_2 = {2, 3};
std::vector<int> nums_2_2 = {1, 2};
int val_2 = 4;
int expected_2 = 1;
int result_2 = MinimumTimeRequired(nums_1_2, nums_2_2, val_2);
assert(result_2 == expected_2);
//TEST_END

//TEST
std::vector<int> nums_1_3 = {1, 1, 1};
std::vector<int> nums_2_3 = {0, 0, 0};
int val_3 = 3;
int expected_3 = 0;
int result_3 = MinimumTimeRequired(nums_1_3, nums_2_3, val_3);
assert(result_3 == expected_3);
//TEST_END

//TEST
std::vector<int> nums_1_4 = {3, 4, 5};
std::vector<int> nums_2_4 = {2, 1, 3};
int val_4 = 6;
int expected_4 = 3;
int result_4 = MinimumTimeRequired(nums_1_4, nums_2_4, val_4);
assert(result_4 == expected_4);
//TEST_END

//TEST
std::vector<int> nums_1_5 = {2, 3, 4};
std::vector<int> nums_2_5 = {1, 2, 3};
int val_5 = 5;
int expected_5 = 3;
int result_5 = MinimumTimeRequired(nums_1_5, nums_2_5, val_5);
assert(result_5 == expected_5);
//TEST_END

//TEST
std::vector<int> nums_1_6 = {1, 2, 3};
std::vector<int> nums_2_6 = {0, 1, 2};
int val_6 = 3;
int expected_6 = 2;
int result_6 = MinimumTimeRequired(nums_1_6, nums_2_6, val_6);
assert(result_6 == expected_6);
//TEST_END

//TEST
std::vector<int> nums_1_7 = {1, 1, 1, 1};
std::vector<int> nums_2_7 = {0, 0, 0, 0};
int val_7 = 4;
int expected_7 = 0;
int result_7 = MinimumTimeRequired(nums_1_7, nums_2_7, val_7);
assert(result_7 == expected_7);
//TEST_END

//TEST
std::vector<int> nums_1_8 = {1, 2, 3, 4};
std::vector<int> nums_2_8 = {0, 1, 2, 3};
int val_8 = 4;
int expected_8 = 4;
int result_8 = MinimumTimeRequired(nums_1_8, nums_2_8, val_8);
assert(result_8 == expected_8);
//TEST_END

//TEST
std::vector<int> nums_1_9 = {1, 2, 3, 4};
std::vector<int> nums_2_9 = {1, 2, 3, 4};
int val_9 = 5;
int expected_9 = -1;
int result_9 = MinimumTimeRequired(nums_1_9, nums_2_9, val_9);
assert(result_9 == expected_9);
//TEST_END

//TEST
std::vector<int> nums_1_10 = {};
std::vector<int> nums_2_10 = {};
int val_10 = 1;
try {
    MinimumTimeRequired(nums_1_10, nums_2_10, val_10);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_11 = {1001}; 
std::vector<int> nums_2_11 = {0};
int val_11 = 1000001; 
try {
    MinimumTimeRequired(nums_1_11, nums_2_11, val_11);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_12 = {1};
std::vector<int> nums_2_12 = {-1};
int val_12 = -1; 
try {
    MinimumTimeRequired(nums_1_12, nums_2_12, val_12);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_13 = {1, 2, 3};
std::vector<int> nums_2_13 = {0, 0, 0};
int val_13 = 0; 
int result_13 = MinimumTimeRequired(nums_1_13, nums_2_13, val_13);
assert(result_13 == 3);
//TEST_END

//TEST
std::vector<int> nums_1_14 = {-1000};
std::vector<int> nums_2_14 = {0};
int val_14 = 1000000;
try {
    MinimumTimeRequired(nums_1_14, nums_2_14, val_14);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_15 = {1, 2, 3};
std::vector<int> nums_2_15(1e6,1); 
int val_15 = 4;
try {
    MinimumTimeRequired(nums_1_15, nums_2_15, val_15);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_16 = {1, 2, 3};
std::vector<int> nums_2_16 = {0, -1, 0};
int val_16 = 4;
try {
    MinimumTimeRequired(nums_1_16, nums_2_16, val_16);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_17(1e6,1);
std::vector<int> nums_2_17 = {1,2};
int val_17 = -1;
try {
    MinimumTimeRequired(nums_1_17, nums_2_17, val_17);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_18 = {1001}; 
std::vector<int> nums_2_18 = {0};
int val_18 = 1000001; 
try {
    MinimumTimeRequired(nums_1_18, nums_2_18, val_18);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_19 = {1};
std::vector<int> nums_2_19 = {-1}; 
int val_19 = -1; 
try {
    MinimumTimeRequired(nums_1_19, nums_2_19, val_19);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END


//TEST
std::vector<int> nums_1_20 = {-1}; 
std::vector<int> nums_2_20 = {0};
int val_20 = 1;
try {
    MinimumTimeRequired(nums_1_20, nums_2_20, val_20);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_21 = {1,2,3};
std::vector<int> nums_2_21 = {2,1};
int val_21 = -1;
try {
    MinimumTimeRequired(nums_1_21, nums_2_21, val_21);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END

//TEST
std::vector<int> nums_1_22 = {6};
std::vector<int> nums_2_22 = {6};
int val_22 = -100; 
try {
    MinimumTimeRequired(nums_1_22, nums_2_22, val_22);
    assert(false);
} catch(const std::invalid_argument& e) {
    assert(true);
}
//TEST_END 
  return 0;
}
