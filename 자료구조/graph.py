import numpy as np
import matplotlib.pyplot as plt

# 한글 폰트 설정 (운영체제에 맞게 선택)
# Windows의 경우 'Malgun Gothic', Mac의 경우 'AppleGothic'을 사용합니다.
plt.rcParams['font.family'] = 'Malgun Gothic' 
plt.rcParams['axes.unicode_minus'] = False # 마이너스 기호 깨짐 방지

# 데이터 입력
n = [100, 1000, 5000, 10000, 50000, 100000]

# 각 알고리즘의 수행 시간 (초)
time_n2 = [
    0.000639999999999982, 
    0.02896799999999997, 
    0.296429, 
    1.075778, 
    26.467117000000002, 
    105.120362
]

time_nlogn = [
    3.6999999999884e-05, 
    0.000253000000000032, 
    0.000612000000000014, 
    0.001269000000001866, 
    0.00713499999998115, 
    0.0156620000000606
]

time_n = [
    6.4999999999909e-05, 
    8.999999999998e-05, 
    0.000163000000000242, 
    0.00030400000000082, 
    0.00147599999967022, 
    0.00296099999991032
]

# 그래프 크기 설정 (권장 크기 비율 반영)
plt.figure(figsize=(10, 6))

## plt.yscale('log')

# 그래프 그리기
plt.plot(n, time_n2, marker='o', label='O(n²)', color='red', linewidth=2)
plt.plot(n, time_nlogn, marker='s', label='O(n log n)', color='blue', linewidth=2)
plt.plot(n, time_n, marker='^', label='O(n)', color='green', linewidth=2)

# 축 라벨 및 제목 설정
plt.xlabel('input size n', fontsize=12)
plt.ylabel('execute time (s)', fontsize=12)
plt.title('compare each algorithm', fontsize=14)

# 그리드 및 범례 추가
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend(fontsize=11)

# 그래프 여백 조정 및 출력
plt.tight_layout()
plt.show()
