# Feature numbers
# 0       1 2 3  4   5    6 7  8   9    10      11      12   13 14      15        16      17       18    19           20         21   22 23     24    25
# England a E En Eng Engl d nd and land england initial none 20 no-male no-female surname no-month place no-publisher no-journal none 0  others other isbn

u:%x[-3,0]
u:%x[-2,0]
u:%x[-1,0]
u:%x[0,0]
u:%x[1,0]
u:%x[2,0]
u:%x[3,0]
u:%x[-1,0]/%x[0,0]
u:%x[0,0]/%x[1,0]

# last character type
u:%x[0,1]
u:%x[-1,1]

# first 1-4 characters
u:%x[0,2]
u:%x[0,3]
u:%x[0,4]
u:%x[0,5]

# last 1-4 characters
u:%x[0,6]
u:%x[0,7]
u:%x[0,8]
u:%x[0,9]

# no punctuation lower-case
u:%x[-2,10]
u:%x[-1,10]
u:%x[0,10]
u:%x[1,10]
u:%x[2,10]

# capitalization
u:%x[0,11]

# numbers
u:%x[-1,12]
u:%x[0,12]
u:%x[1,12]
u:%x[-1,12]/%x[0,12]
u:%x[0,12]/%x[1,12]

# dictionary
u:%x[0,13]
u:%x[0,14]
u:%x[0,15]
u:%x[0,16]
u:%x[0,17]
u:%x[0,18]
u:%x[0,19]
u:%x[0,20]

# possible editor
u:%x[0,21]

# position
u:%x[0,22]

# punctuation
u:%x[0,23]

# possible chapter
u:%x[-1,23]/%x[0,24]/%x[0,21]
u:%x[-1,23]/%x[0,24]/%x[1,11]

# reference
u:%x[0,25]
u:%x[0,25]/%x[1,12]

# bigram
b
