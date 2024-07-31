# 중심극한 정리 알아보기
  # n ≥ 30 이면 원점수의 분포가 정상분포가 아니어도 
  # 평균 분포는 정상분포에 가까워지는지 눈으로 확인해보자

# 표본 크기(n)가 커지면 평균 분포의 표준오차가 작아지는지
# (빈도 분포의 폭이 좁아지는지) 눈으로 확인해보자


rm(list=ls())  # Environment 비우기

dat = read.csv("StudentHeights_MoE2016.csv", fileEncoding="EUC-KR")
all_ht = dat[,5]  # 모든 학생들의 키만 가져오기

# 그래프 그릴 때 오류가 발생하지 않도록 그래프 여백 설정
par(mar=c(4.5,4.5,1,1), cex=0.75)
# 그래프를 위/아래 두개(2행 1열)로 그리도록 설정
par(mfrow=c(2,1))

# 모든 학생의 키 빈도분포를 히스토그램으로 그림
hist(all_ht, breaks=seq(90, 200, by=1)) # 90에서 100까지, 간격크기 1

n_smpl = 30  # 하나의 표본 크기(표본 안의 데이터 개수)
sampling = 5000  # 표본을 추출할 횟수
smpl_Ms = rep(0, sampling)  # 추출한 모든 표본의 평균을 담을 변수

for (i in 1:sampling) {  # { }안의 내용을 5000번 반복
  X_smpl = sample(       # sample( ) 함수는
    all_ht,              # 첫번째 입력값 배열에서
    n_smpl,              # 두번째 입력값 숫자만큼
                         # 무선표집한 결과를 배열로 만들어줌
    replace=TRUE)       # replace라는 이름의 입력값이
                         # TRUE면 복원 추출, FALSE면 비복원 추출
  
  smpl_Ms[i] = mean(X_smpl)  # 무선표집한 표본에서 평균을 계산해서
                             # smpl_Ms 배열의i 번째 칸에 입력
}

# 각 표본의 평균들(smpl_Ms)의 빈도분포를 히스토그램으로 그림
hist(smpl_Ms, breaks=seq(90, 200, by=1))
