import random
import time
import matplotlib.pyplot as plt

## [0] list A 생성

n = int(input("정수 n을 입력하시오. (설정 범위 [-n, n]) : "))              # n 입력받기
random.seed(12)
A =[]                                                               # list A 생성
for _ in range (0, n):                                              # [-n, n] 범위의 수 랜덤하게 생성하여 리스트 A에 저장
    a = random.randrange(-n, n)
    A.append(a)
# print(f"list A: {A}")                                               # A 출력

## [1] O(n^2) 알고리즘
def ON2_count(A):
    before = time.process_time()
    cnt = 0
    c=0
    for i in range(0, n):                                           # 이중 for문으로 모든 경우의 수 비교
        duplicate = False                                           # duplicate를 False로 가정하기
        for j in range(0, i):                                       # A[i] == A[j]인 경우, duplicate를 True로 바꾸고 j반복문 빠져나오기
            if (A[i] == A[j]):
                duplicate = True
                break
        if duplicate == False:                                      # duplicate가 False일 경우, i에 해당하는 값 앞부분에서 유일하므로 카운트하기
            cnt += 1
    after = time.process_time()
# print
    print("== [1] O(n^2) algorithm ==")
    print(f"result: {cnt}")
    print(f"time: {after - before}")


## [2] O(nlogn) 알고리즘
def ONLOGN_count(A):
    before = time.process_time()
    A.sort()                                                        # 정렬
    cnt = 0
    for i in range(0, n-1):                                         # 인덱스에러 방지를 위해서 n-2까지 반복 (i+1)과 비교하기 때문
        if A[i] != A[i+1]:                                          # A[i] 와 A[i+1]이 다르면 카운트하기
            cnt += 1
    cnt += 1
    after = time.process_time()
# print
    print("== [2] O(nlogn) algorithm ==")
    print(f"result: {cnt}")
    print(f"time: {after - before}")


## [3] O(n) 알고리즘 
def ON_count(A):
    before = time.process_time()
    cnt = 0
    dA = dict.fromkeys(A)                                           # dA라는 dictionary에 list A를 각각 key가 되도록 넣기
    cnt = len(dA)                                                   # dA의 길이 측정(dictionary key는 중복을 허용하지 않음!)
    after = time.process_time()
    # print
    print("== [3] O(n) algorithm ==")
    print(f"result: {cnt}")
    print(f"time: {after - before}")


## [4] 추가 알고리즘: 


## [5] 실행

ON2_count(A)
ONLOGN_count(A)
ON_count(A)
print ("============================")
print(f"correct : {len(set(A))}")