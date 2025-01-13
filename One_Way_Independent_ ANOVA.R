# ----------------------------------------
# 1. 데이터 입력 및 준비
# ----------------------------------------

# (1) 집단 정보 입력
# `factor()` 함수: 범주형 변수를 생성합니다. 독립 변수는 반드시 요인(factor)으로 지정해야 합니다.
school <- factor(c(1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3))  # 3개의 학교 (집단)

# (2) 종속 변수 입력
# 수학 성취도 점수 입력
mathach <- c(5, 3, 2, 6, 9, 10, 7, 10, 6, 9, 8, 9)

# (3) 데이터 프레임 생성
# `data.frame()` 함수: 독립 변수와 종속 변수를 결합하여 데이터 프레임 생성
df <- data.frame(school, mathach)

# 데이터 확인
print("데이터 프레임:")
print(df)
View(df)  # 데이터 프레임을 테이블 형태로 보기 (RStudio 전용)

# ----------------------------------------
# 2. 기본 분석: 일원 독립집단 분산분석
# ----------------------------------------

# (1) ANOVA 모델 생성
# `aov()` 함수: 분산 분석 모델 생성
# formula = 종속변수 ~ 독립변수
fit <- aov(mathach ~ school, data = df)

# (2) 결과 요약
# `summary()` 함수: 분석 결과 요약 (F값, p-value 등)
print("분산분석 결과:")
summary(fit)

# ----------------------------------------
# 3. 효과 크기 계산 (eta-squared)
# ----------------------------------------

# (1) 패키지 설치 및 로드
# `etaSquared()` 함수: 효과 크기 계산
install.packages('lsr')  # 최초 1회 설치 필요
library(lsr)

# (2) 효과 크기 계산
# eta-squared 값: 독립 변수가 종속 변수의 변화를 설명하는 비율
eta_squared <- etaSquared(fit)
print("효과 크기 (eta-squared):")
print(eta_squared)

# ----------------------------------------
# 4. 추가 분석: 사후 검증
# ----------------------------------------

# (1) 집단별 기술통계
# `describeBy()` 함수: 각 집단의 요약 통계량 확인
install.packages('psych')  # 최초 1회 설치 필요
library(psych)
describeBy(x = mathach, group = school, data = df)

# (2) 사후 검증 (LSD t-test)
# `pairwise.t.test()` 함수: 집단 간 평균 차이 검정
# p.adjust.method = "none": p-value 조정 없음
pairwise.t.test(x = df$mathach, g = df$school, p.adjust.method = 'none')

# (3) Bonferroni correction
# p.adjust.method = "bonferroni": p-value를 보수적으로 조정
pairwise.t.test(x = df$mathach, g = df$school, p.adjust.method = 'bonferroni')

# (4) Tukey's HSD Test
# `TukeyHSD()` 함수: Tukey의 사후 검증 수행
# Tukey HSD는 ANOVA 모델(fit)에서만 실행 가능
print("Tukey's HSD Test 결과:")
TukeyHSD(fit)

# (5) Scheffe Test
# `ScheffeTest()` 함수: Scheffe 사후 검증
install.packages('DescTools')  # 최초 1회 설치 필요
library(DescTools)
ScheffeTest(fit)

# ----------------------------------------
# 5. 분석의 가정 확인
# ----------------------------------------

# (1) Q-Q plot 생성
# Q-Q plot: 잔차가 정규 분포를 따르는지 시각적으로 확인
print("Q-Q Plot:")
plot(fit, which = 2)  # 전체 잔차를 사용한 Q-Q plot

# (2) 각 집단별 잔차 생성
# `fit$residuals`: 모델의 잔차
resid1 <- fit$residuals[df$school == 1]  # 학교 1의 잔차
resid2 <- fit$residuals[df$school == 2]  # 학교 2의 잔차
resid3 <- fit$residuals[df$school == 3]  # 학교 3의 잔차

# (3) 각 집단의 Q-Q plot
qqnorm(resid1); qqline(resid1, col = "blue")  # 학교 1
qqnorm(resid2); qqline(resid2, col = "blue")  # 학교 2
qqnorm(resid3); qqline(resid3, col = "blue")  # 학교 3

# (4) Shapiro-Wilk Test
# `shapiro.test()` 함수: 정규성 검정
# p-value > 0.05이면 정규성을 만족
print("Shapiro-Wilk Test 결과:")
shapiro.test(resid1)
shapiro.test(resid2)
shapiro.test(resid3)
