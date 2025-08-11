#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul 18 10:14:52 2025

@author: kennyaskelson
"""

#python practice!

# This checks if a matrix has diagonal matching values

def is_same_stripes(matrix):
  for i in range(len(matrix)):
    for j in range(len(matrix[0])):
      if i == max(range(len(matrix))):
        break
      elif j == max(range(len(matrix[0]))):
        break
      elif matrix[i][j] != matrix[i + 1][j + 1]:
        return False
      elif matrix[i][j] == matrix[i + 1][j + 1]:
        continue
  return True


# does factorial (given a number it multiples all the numbers in the range)
# in other words for 10 would be 1*2*3,...,*10

def factorial(n):
  mult = 1
  for i in range(1, n + 1):
    mult *= i
  return mult

# finds the intersection of two lists

def intersection(a, b):
  overlap = []
  for i in range(len(a)):
    for j in range(len(b)):
      if a[i] == b[j]:
        overlap.append(a[i])
      elif a[i] != b[j]:
        continue
  return overlap

#this takes a list of digits combines into one number, adds 1, then splits it back into digits

def another_one(digits):
  number = int("".join([str(i) for i in digits]))
  another_one = number+1
  another_one_str = [int(x) for x in str(another_one)]
  return another_one_str


strength= [[1, 10, 4, 2], [9, 3, 8, 7], [15, 16, 17, 12]]

#finds max value in column and min in row 

def weakest_strong_link(matrix):
  link = -1
  for i in range(len(matrix[0])):
    for j in range(len(matrix)):
      if max([row[i] for row in matrix]) == min(matrix[j]):
        link = matrix[j][i]
        break 
  return link

weakest_strong_link(strength)


#function finds multiple of 3 and 5 of number and sums 

target = 10 

def fizz_buzz_sum(target):
  threes = []
  fives = []
  i3 = 1
  i5 = 1
  while True:
    three_temp = 3 * i3
    if three_temp < target:
      threes.append(three_temp)
      i3 += 1
    else:
      break
  while True:
     five_temp = 5 * i5
     if five_temp < target:
      fives.append(five_temp)
      i5 += 1
     else:
          break
  diff = set(threes) - set(fives)
  final = fives + list(diff)
  return sum(final)

fizz_buzz_sum(target)

### this is the clean solution 

def fizz_buzz_sum(target):
  sum = 0
  for i in range(target):
    if (i % 3 == 0) or (i % 5 == 0): # this says if no remainder for division of 3 or 5 then add
      sum += i
  return sum



#compound interest calculator with contributions  

def compound_interest(principal, rate, contribution, years):
  new_rate = (rate/100)
  compound = (principal*(1+new_rate)**years) + contribution * (((1+new_rate)**years - 1) / new_rate)
  return round(compound, 2)

compound_interest(500, 10, 50, 3)



#what a pain in the butt. Takes a number that gets the word for the number and the word for all the previous numbers and counts the number of letters

def total_letters(N):
    word = []
    num_to_letters = {
        1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five',
        6: 'six', 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten', 
        11: 'eleven', 12: 'twelve', 13: 'thirteen', 
        14: 'fourteen', 15: 'fifteen', 16: 'sixteen', 
        17: 'seventeen', 18: 'eighteen', 19: 'nineteen', 
        20: 'twenty', 30: 'thirty', 40: 'forty', 50: 'fifty', 
        60: 'sixty', 70: 'seventy', 80: 'eighty', 90: 'ninety',
        1000: 'onethousand'
    }
    for i in range(1, N+1):
        if i <= 20:
            word.append(num_to_letters[i])
        elif i > 20 and i < 100:
            rounded = round(i, ndigits=-1)
            rounded_diff = i - rounded
            if rounded_diff == 0:
                word.append(num_to_letters[i]) 
            elif rounded_diff > 0:
                word.append(f'{num_to_letters[rounded]}{num_to_letters[rounded_diff]}')
            elif rounded_diff < 0:
                second_num = 10 + rounded_diff
                first_num = rounded - 10
                word.append(f'{num_to_letters[first_num]}{num_to_letters[second_num]}')
        elif i == 1000:
            word.append(num_to_letters[i])
        elif i >= 100 and i <= 999:
           hundo = num_to_letters[int(i / 100)]
           if (int(i / 100))*100 - i == 0:
               word.append(f'{hundo}{"hundred"}') 
           elif (int(i / 100))*100 - i != 0:
               remaining = abs((int(i / 100))*100 - i)
               if remaining <= 20:
                   word.append(f'{hundo}{"hundred"}{"and"}{num_to_letters[remaining]}')
               elif remaining > 20 and remaining < 100:
                   rounded = round(remaining, ndigits=-1)
                   rounded_diff = remaining - rounded
                   if rounded_diff == 0:
                       word.append(f'{hundo}{"hundred"}{"and"}{num_to_letters[remaining]}') 
                   elif rounded_diff > 0:
                       word.append(f'{hundo}{"hundred"}{"and"}{num_to_letters[rounded]}{num_to_letters[rounded_diff]}')
                   elif rounded_diff < 0:
                       second_num = 10 + rounded_diff
                       first_num = rounded - 10
                       word.append(f'{hundo}{"hundred"}{"and"}{num_to_letters[first_num]}{num_to_letters[second_num]}')
    
    return len(''.join(word))

total_letters(5)




#Let nums comprise of n elements. If n == 1, end the process. Otherwise, create a new integer array newNums of length n - 1.
#For each index i, assign the value of newNums[i] as (nums[i] + nums[i+1]) % 10, where % denotes the modulo operator.
#Replace the array nums with newNums.
#Repeat the entire process starting from step 1.

# I couldn't figure this one out so I walked through the solution and commented
# seem obvious now

def triangular_sum(nums):
    while len(nums)>1: # run opperation while length nums greater than 1
        next_nums = [] # intilize next numbers
        for i in range(1,len(nums)):
            next_nums.append((nums[i-1]+nums[i])%10) #run loop opperation
        nums = next_nums # assign th next numbers to nums
    return nums[0]


test = [1, 3, 5, 7]

triangular_sum(test)


#check is list of numbers has duplicates if so return true if not return false

def contains_duplicate(input):
    for x in range(len(input)):
        for i in range(x, len(input)-1):
            if input[x] == input[i + 1]:
                return True
    return False

contains_duplicate([1,2,3])


#converts roman numerals to numbers
#for roman numerals if a small number preceeds a larger number it's subtraction
#if larger number preceds it's addition

def romanToInt(s):
  rom_to_num = {'I': 1, 
                'V': 5, 
                'X': 10, 
                'L': 50, 
                'C': 100, 
                'D': 500, 
                'M': 1000}
  
  split = [x for x in str(s)]
  numbers = []
  tmp_numbers = []
  if len(split) == 1:
      roman = split[0]
      numbers = rom_to_num[roman]
  elif len(split) > 1:
      for i in range(len(split) - 1):
          rom1 = split[i]
          rom2 = split[i + 1]
          if rom_to_num[rom1] >= rom_to_num[rom2]:
              tmp_numbers.append(rom_to_num[rom1])
          elif rom_to_num[rom1] < rom_to_num[rom2]:
              negative = (rom_to_num[rom1] * -1)
              tmp_numbers.append(negative)
      fin = split[-1]
      tmp_numbers.append(rom_to_num[fin])
      numbers = sum(tmp_numbers)

  return numbers
      

romanToInt("XI")



#checks if two strings are anograms 

def is_anagram(s, t):
    if sorted(s) == sorted(t):
        return True
    return False


#pascals triange, range doesn't iterate including stop :( 

import math 

def generate(numRows):
    big_list = []
    for row in range(1, numRows + 1):
        if row == 1:
            big_list.append([1])
        elif row > 1:
            values = []
            for item in range(row):
                value = math.comb(row - 1, item)
                values.append(value)
            big_list.append(values)
    return big_list


generate(2)


#gets the longest consequtive sequence data lemur answers a broken

def longest_consecutive(nums):
    sort_seq = sorted(nums)
    seq_counts = []
    for i in range(len(sort_seq) - 1):
        if not seq_counts or seq_counts[-1] == 0:
            if sort_seq[i] + 1 == sort_seq[i + 1]:
                seq_counts.append(1)
            if sort_seq[i] + 1 != sort_seq[i + 1]:
                seq_counts.append(0)
        if seq_counts[-1] >= 1:
            if sort_seq[i] + 1 == sort_seq[i + 1]:
                seq_counts[-1] += 1
            if sort_seq[i] + 1 != sort_seq[i + 1]:
                seq_counts.append(0)
    return max(seq_counts)


longest_consecutive([1,2,3,5,6])


#determines if string is palindrome .lower() gives lower case
# .isalpha() says if is a letter or not

def isPalindrome(phrase):
    phrase_clearn = "".join(char.lower() for char in phrase if char.isalpha())
    if phrase_clearn == phrase_clearn[::-1]:
        return True
    return False


# in a set of expectations and set of cards return what cards will satisfy what expectations
# uses break to count only one expecation

def max_satisfaction(expectations, cards):
    sats = 0
    for a in range(len(expectations)):
        for b in range(len(cards)):
            if (expectations[a] / cards[b]) <= 1:
                sats += 1
                break
    return sats

max_satisfaction([5, 20, 1000], [10, 15, 100])


# check if number is looping (sum of number components squared i.e, 16 would be 1^2 + 6^2 
# and that returned back to it's original number. Numbers less than 3 loop forever. 
# list comprehension was the move here

def is_looping(n):
    if n <= 3:
        return False 
    if n >= 4 and n < 10:
        start = [n ** 2]
    else:
        start = [n]
    while True:
        digits = [int(d) for d in str(start[-1])]
        sum_square = sum(d**2 for d in digits)
        start.append(sum_square)
        if sum_square == n or sum_square == 1:
            break
    if sum_square == n:
        return True
    if sum_square == 1:
        return False
    
is_looping(3)


# rotate matrix to see if it matches target. Uses numpy rot90 and if all cells are TRUE

import numpy as np

def find_rotation(mat, target):
    new_mat = mat
    for i in range(4):
        new_mat = np.rot90(new_mat)
        if (new_mat == target).all():
            return True
    return False

find_rotation([[0, 1],[1, 0]], [[1, 1],[0, 0]])


# this function rotates a matrix 90 degree
# I realzed to rotate is you need to grab the last digit of the original list in a new list
# then reverse the list 

def rotate(matrix):
    big_list = []
    for x in range(len(matrix)):
        small_list = []
        for y in range(len(matrix)):
            small_list.append(matrix[y][x])
            if y == max(range(len(matrix))):
                small_list.reverse()
        big_list.append(small_list)
    return big_list

rotate([[1]])


#finds sub lists of 3 sequential numbers of the original list, then finds the
#maximum of the sublist means 

def max_avg_subarray(nums, k):
    if k == 1 or len(nums) == 1:
        return max(nums)
    k_one = k - 1
    means = []
    for x in range(len(nums)-k_one):
        tmp_num = []
        for y in range(k):
           tmp_num.append(nums[x + y])
        mean = sum(tmp_num)/k
        means.append(mean)
    return round(max(means), 2)

max_avg_subarray([1, 2, -5, -3, 10, 3], 3)


# this function is basically a sliding window
# given an array take the average for the sliding windows across the array with padding on either side 

def k_radius_avg(nums, k):
    if len(nums) == 1:
        return [-1]
    if k == 0:
        return nums
    if len(nums) < ((k * 2) + 1):
        newnums = []
        [newnums.append(-1) for i in range(len(nums))]
        return newnums
    k_window = (k * 2) + 1

    round_down = int(len(nums)/2)

    newnums = []

    [newnums.append(-1) for i in range(k)]

    for x in range(round_down):
        avg = round((sum(nums[x + y] for y in range(k_window))) / k_window, 2)
        newnums.append(avg)
         
    [newnums.append(-1) for i in range(k)]

    return newnums


k_radius_avg([2, 5, 9, 8, 9, 43, 10, 11, 10, 50, 33, 21], 10)



# this finds days in a list of lists that are availble (in number of set days)

def gpu_idle_days(days, training_sessions):
    
    full_days = [num for num in range(1,days + 1)]

    nums = [range(x[0], x[1] + 1) for x in training_sessions]

    numbers = []
    for y in range(len(nums)):
        for x in nums[y]:
            numbers.append(x)

    available = set(full_days) - set(numbers) # cool list subtraction! finds whats available in the full list by subtracting the scheduled days!  

    return len(available)


gpu_idle_days(9, [[2, 4], [1, 5], [7, 8]])


# Ok I really didn't get this one but it's a recursion/fibonnaci sequence i.e., sum of preceeding numbers
# So in this solution you have to climb a mountain height n with either 1 or 2 steps, and you have to count the number
# of ways to climb n height mountain with various 1's and 2's.
# So for this you use recursion in the function where at any given step n, your previou step is either n-1 for one step
# or n-2 for two step, and it's the sum of those two, and you recurse all the way back. 

def climb_hill(n):
    if n == 0 or n == 1:
        return 1
    return climb_hill(n - 1) + climb_hill(n - 2)

# this is way easier to understand, just sum the two previous numbers in range n
def climb_hill(n):
  res = [0,1]
  for i in range(n):
    res.append(res[-1]+res[-2])
  return res[-1]

feed_items = [1, 2, 0, 0, 0]
n = 3

# in this question you are given a series of 0,1,2 and you want to insert n number of 1's. 1's cannot
# go next to 1 or 2 and can go at the ends if ends are zero. You need to return true if you can insert n
# number of 1's or false if you cant
# because we are adding to the feed items, we can get extra counts, so the counter needs to be greater than n

def can_insert_ads(feed_items, n):
    if n == 0:
        return True 
    if feed_items[0] == 0:
        feed_items.insert(0, 0)
    if feed_items[-1] == 0:
         feed_items.append(0)
    counter = 0
    for i in range(len(feed_items)):
        if feed_items[i] == 1:
            counter += 0
        if feed_items[i] == 2:
            counter += 0
        if feed_items[i] == 0 and (feed_items[i - 1] == 0 or feed_items[i + 1] == 0):
            counter += 1
    if counter > n:
        return True
    else:
        return False
                   
                   
can_insert_ads([1, 2, 0, 0, 0], 3)
    