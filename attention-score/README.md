# Transformer Attention Score 연산기 (Verilog)

본 프로젝트는 Transformer 모델의 핵심 연산인 **Attention Score**를 Verilog로 구현한 하드웨어 가속기 개인용 프로젝트 입니다.  
특히 **부동소수점 연산기(FPU)**를 직접 구현하여 Attention Score를 계산하며, 이후 **Systolic Array** 구조 확장 가능성을 탐구한 연구 성과를 담고 있습니다.  

---

## 📌 프로젝트 개요
- **배경**  
  Transformer의 Attention 연산은 매우 높은 연산량을 요구합니다. 이를 하드웨어 가속기로 구현하면 **지연(latency)** 을 줄이고 **전력 효율성**을 높일 수 있습니다.  

- **목표**  
  1. Verilog로 Attention Score 연산기 설계  
  2. Half Precision(16-bit) 부동소수점 연산기(FPU) 구현  
  3. FPGA/시뮬레이터에서 동작 검증  
  4. (추후) Systolic Array 기반 확장  

- **성과**  
  2023 한국전기전자학회 학술대회 발표  

---
## 🛠 기술 스택
- Verilog HDL
- FPGA 시뮬레이션 환경 (Vivado)
- ModelSim (파형 확인용)

---

## ⚙️ 구현 내용
1. **행렬 곱 모듈 (Baseline)**  
- Query(Q) × Key^T / sqrt(d) → Attention Score

2. **부동소수점 연산기 (IEEE 754 Half Precision, 16-bit)**  
   - 부호(1bit) | 지수(5bit) | 가수(10bit)  
   - 곱셈기, 덧셈기, 정규화 및 예외 처리 포함  

3. **전체 설계 구조**
   - `attention.v` 파일 내부에 **설계부 + 테스트 데이터** 포함  
   - 별도 Testbench 파일 없음  
   - **⚠️ clk, rst 신호는 사용자가 직접 제공해야 함**  

4. **추후 확장**
   - **Systolic Array** 구조 적용 가능성 검토  
   - 파이프라인 최적화 및 병렬 연산 확장  

---

## ▶️ 사용 방법

1. **파일 준비**
   - src 폴더 파일을 시뮬레이션 환경(Vivado, ModelSim 등)에 추가  

2. **클럭 & 리셋 생성 (예시)**
   ```verilog
   reg clk, rst;
   always #5 clk = ~clk;  // 100MHz 클럭

   initial begin
       clk = 0;
       rst = 1;
       #20 rst = 0;       // 리셋 해제
   end

---

## 📖 참고

- IEEE 754 Half Precision Floating Point 구조
- Transformer Attention 메커니즘 (Q × K^T / sqrt(dk))
