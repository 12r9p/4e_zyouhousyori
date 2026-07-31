import os
import subprocess
import re
import math
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl

# Matplotlib Japanese and Excel style configuration
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['font.sans-serif'] = ['Hiragino Sans', 'Hiragino Kaku Gothic Pro', 'IPAexGothic', 'MS Gothic', 'DejaVu Sans', 'sans-serif']
plt.rcParams['axes.unicode_minus'] = False

# Excel-like grid and border style
plt.rcParams['axes.facecolor'] = 'white'
plt.rcParams['axes.edgecolor'] = '#d9d9d9'
plt.rcParams['axes.linewidth'] = 1.0
plt.rcParams['grid.color'] = '#d9d9d9'
plt.rcParams['grid.linestyle'] = '-'
plt.rcParams['grid.linewidth'] = 0.8
plt.rcParams['legend.edgecolor'] = '#d9d9d9'
plt.rcParams['legend.fancybox'] = False
plt.rcParams['legend.framealpha'] = 1.0

# Excel colors
EXCEL_BLUE = '#4472c4'
EXCEL_ORANGE = '#ed7d31'
EXCEL_GRAY = '#7f7f7f'
EXCEL_YELLOW = '#ffc000'
EXCEL_GREEN = '#70ad47'

# Working directories
BASE_DIR = "/Users/takumi/Documents/4e_zyouhousyori/2Q_report"
DATA_DIR = os.path.join(BASE_DIR, "data")
PLOTS_DIR = os.path.join(BASE_DIR, "plots")

os.makedirs(DATA_DIR, exist_ok=True)
os.makedirs(PLOTS_DIR, exist_ok=True)

# ----------------------------------------------------
# Helper to compile and run C programs
# ----------------------------------------------------
def compile_c(source_name, binary_name):
    source_path = os.path.join(BASE_DIR, source_name)
    binary_path = os.path.join(BASE_DIR, binary_name)
    print(f"Compiling {source_name} -> {binary_name}...")
    subprocess.run(["gcc", "-o", binary_path, source_path, "-lm"], check=True)
    return binary_path

def run_binary(binary_path, input_str):
    print(f"Running {os.path.basename(binary_path)}...")
    proc = subprocess.run(
        [binary_path],
        input=input_str,
        capture_output=True,
        text=True,
        check=True
    )
    return proc.stdout

# ----------------------------------------------------
# 1. Spline Simulation (Task 7-2)
# ----------------------------------------------------
def step_spline():
    binary_path = compile_c("spline.c", "spline")
    
    # Inputs:
    # m = 3
    # x(0)=0.0, y(0)=1.0
    # x(1)=1.0, y(1)=3.0
    # x(2)=2.0, y(2)=2.0
    # left deriv = 5.0
    # right deriv = 3.0
    # correct? = y
    # segments = 20
    input_str = "3\n0.0\n1.0\n1.0\n3.0\n2.0\n2.0\n5.0\n3.0\ny\n20\n"
    stdout = run_binary(binary_path, input_str)
    
    # Save stdout log for reference
    with open(os.path.join(DATA_DIR, "spline_log.txt"), "w") as f:
        f.write(stdout)
        
    # Parse interpolated values
    # Format is: "  0.000000    1.000000"
    lines = stdout.strip().split("\n")
    results = []
    # Find start of table data
    table_started = False
    for line in lines:
        parts = line.split()
        if len(parts) == 2:
            try:
                x_val = float(parts[0])
                y_val = float(parts[1])
                # We expect values between 0.0 and 2.0
                if 0.0 <= x_val <= 2.01:
                    results.append((x_val, y_val))
                    table_started = True
            except ValueError:
                pass
    
    df = pd.DataFrame(results, columns=["x", "y"])
    df.to_csv(os.path.join(DATA_DIR, "spline_output.csv"), index=False)
    
    # Plot spline
    plt.figure(figsize=(6, 4))
    plt.plot(df["x"], df["y"], label="スプライン補間 (20等分)", color=EXCEL_BLUE, linewidth=1.5)
    plt.scatter([0.0, 1.0, 2.0], [1.0, 3.0, 2.0], color=EXCEL_ORANGE, s=80, zorder=5, label="データ点")
    plt.title("3次スプライン補間")
    plt.xlabel("x")
    plt.ylabel("y")
    plt.grid(True)
    plt.legend(loc="upper right")
    plt.tight_layout()
    plt.savefig(os.path.join(PLOTS_DIR, "spline_plot.png"), dpi=150)
    plt.close()
    print("Spline simulation done.")

# ----------------------------------------------------
# 2. Least Squares (Task 8-1 / 8-2)
# ----------------------------------------------------
def step_least_squares():
    binary_path = compile_c("minjijo.c", "minjijo")
    
    # Task 8-1: Linear Fit (y = a*x + b)
    # f(x) = 1 (x)
    # g(x) = 4 (1.0)
    # n = 5
    # (1.0, 2.0), (2.0, 2.5), (3.0, 2.9), (4.0, 3.5), (5.0, 4.4)
    # y (correct)
    # \n (enter key for table)
    input_str_1 = "1\n4\n5\n1.0\n2.0\n2.0\n2.5\n3.0\n2.9\n4.0\n3.5\n5.0\n4.4\ny\n\n"
    stdout_1 = run_binary(binary_path, input_str_1)
    
    with open(os.path.join(DATA_DIR, "minjijo_log_1.txt"), "w") as f:
        f.write(stdout_1)
        
    # Parse 8-1 table
    lines_1 = stdout_1.strip().split("\n")
    results_1 = []
    for line in lines_1:
        parts = line.split()
        if len(parts) == 2:
            try:
                x_val = float(parts[0])
                y_val = float(parts[1])
                if 1.0 <= x_val <= 5.01:
                    results_1.append((x_val, y_val))
            except ValueError:
                pass
    df_1 = pd.DataFrame(results_1, columns=["x", "y"])
    df_1.to_csv(os.path.join(DATA_DIR, "minjijo_output_1.csv"), index=False)
    
    # Task 8-2: Reciprocal + Linear (y = a/x + b*x)
    # f(x) = 2 (1/x)
    # g(x) = 1 (x)
    # n = 7
    # (0.2, 12.1), (0.5, 4.9), (1.0, 2.9), (2.0, 2.1), (4.0, 2.1), (8.0, 3.4), (10.0, 4.3)
    # y (correct)
    # \n (enter key for table)
    input_str_2 = "2\n1\n7\n0.2\n12.1\n0.5\n4.9\n1.0\n2.9\n2.0\n2.1\n4.0\n2.1\n8.0\n3.4\n10.0\n4.3\ny\n\n"
    stdout_2 = run_binary(binary_path, input_str_2)
    
    with open(os.path.join(DATA_DIR, "minjijo_log_2.txt"), "w") as f:
        f.write(stdout_2)
        
    # Parse 8-2 table
    lines_2 = stdout_2.strip().split("\n")
    results_2 = []
    for line in lines_2:
        parts = line.split()
        if len(parts) == 2:
            try:
                x_val = float(parts[0])
                y_val = float(parts[1])
                if 0.2 <= x_val <= 10.01:
                    results_2.append((x_val, y_val))
            except ValueError:
                pass
    df_2 = pd.DataFrame(results_2, columns=["x", "y"])
    df_2.to_csv(os.path.join(DATA_DIR, "minjijo_output_2.csv"), index=False)
    
    # Plot 8-2
    plt.figure(figsize=(6, 4))
    plt.plot(df_2["x"], df_2["y"], label="最小二乗近似式: y = 2.401/x + 0.398x", color=EXCEL_BLUE, linewidth=1.5)
    plt.scatter([0.2, 0.5, 1.0, 2.0, 4.0, 8.0, 10.0], [12.1, 4.9, 2.9, 2.1, 2.1, 3.4, 4.3], color=EXCEL_ORANGE, s=80, zorder=5, label="データ点")
    plt.title("最小二乗近似")
    plt.xlabel("x")
    plt.ylabel("y")
    plt.grid(True)
    plt.legend(loc="upper right")
    plt.tight_layout()
    plt.savefig(os.path.join(PLOTS_DIR, "minjijo_plot.png"), dpi=150)
    plt.close()
    print("Least squares simulation done.")

# ----------------------------------------------------
# 3. Numerical Integration (Task 9-1 / 9-2)
# ----------------------------------------------------
def step_integration():
    # Task 9-1: Rectangle approximation
    binary_rect = compile_c("tyouhou_mod.c", "tyouhou_mod")
    stdout_rect = run_binary(binary_rect, "")
    with open(os.path.join(DATA_DIR, "integral_rect_log.txt"), "w") as f:
        f.write(stdout_rect)
        
    val_rect = float(re.search(r"積分値\s*=\s*([0-9\.]+)", stdout_rect).group(1))
    df_rect = pd.DataFrame([["Rectangle", val_rect]], columns=["Method", "Value"])
    df_rect.to_csv(os.path.join(DATA_DIR, "integral_rect.csv"), index=False)
    
    # Task 9-2: Trapezoidal formula
    binary_daikei = compile_c("daikei.c", "daikei")
    # Inputs:
    # a = 0.0
    # b = 1.0
    # n = 100
    # y (correct)
    input_str_daikei = "0.0\n1.0\n100\ny\n"
    stdout_daikei = run_binary(binary_daikei, input_str_daikei)
    with open(os.path.join(DATA_DIR, "integral_daikei_log.txt"), "w") as f:
        f.write(stdout_daikei)
        
    val_daikei = float(re.search(r"積分の近似値\s*=\s*([0-9\.]+)", stdout_daikei).group(1))
    df_daikei = pd.DataFrame([["Trapezoidal", val_daikei]], columns=["Method", "Value"])
    df_daikei.to_csv(os.path.join(DATA_DIR, "integral_daikei.csv"), index=False)
    
    print("Integration simulation done.")

# ----------------------------------------------------
# 4. ODE Simulations (Task 11-1)
# ----------------------------------------------------
def step_ode():
    # Euler Method
    binary_euler = compile_c("euler.c", "euler")
    stdout_euler = run_binary(binary_euler, "")
    
    # Runge-Kutta 2nd Order
    binary_rk2 = compile_c("rungekt2.c", "rungekt2")
    stdout_rk2 = run_binary(binary_rk2, "\n") # Stream enter key to proceed
    
    # Parse Euler
    lines_e = stdout_euler.strip().split("\n")
    results_e = {}
    for line in lines_e:
        parts = line.split()
        if len(parts) == 2:
            try:
                x_val = round(float(parts[0]), 3)
                y_val = float(parts[1])
                results_e[x_val] = y_val
            except ValueError:
                pass
                
    # Parse RK2
    lines_rk = stdout_rk2.strip().split("\n")
    results_rk = {}
    for line in lines_rk:
        parts = line.split()
        if len(parts) == 2:
            try:
                x_val = round(float(parts[0]), 3)
                y_val = float(parts[1])
                results_rk[x_val] = y_val
            except ValueError:
                pass
                
    # Align and calculate True Value y = 12x - 8e^x + 9
    aligned_data = []
    x_keys = sorted(list(set(list(results_e.keys()) + list(results_rk.keys()))))
    
    for x_val in x_keys:
        y_euler = results_e.get(x_val, None)
        y_rk2 = results_rk.get(x_val, None)
        y_true = round(12.0 * x_val - 8.0 * math.exp(x_val) + 9.0, 6)
        aligned_data.append((x_val, y_euler, y_rk2, y_true))
        
    df = pd.DataFrame(aligned_data, columns=["x", "y_euler", "y_rk2", "y_true"])
    df.to_csv(os.path.join(DATA_DIR, "ode_output.csv"), index=False)
    
    # Plot ODE comparisons
    plt.figure(figsize=(7, 4.5))
    plt.plot(df["x"], df["y_true"], label="真値 (y = 12x - 8e^x + 9)", color=EXCEL_GRAY, linewidth=2.0)
    plt.plot(df["x"], df["y_rk2"], label="ルンゲ・クッタ2次公式 (h = 0.1)", color=EXCEL_BLUE, marker="o", linestyle="--", markersize=5)
    plt.plot(df["x"], df["y_euler"], label="オイラー法 (h = 0.1)", color=EXCEL_ORANGE, marker="s", linestyle="--", markersize=5)
    plt.title("数値解法の比較")
    plt.xlabel("x")
    plt.ylabel("y")
    plt.grid(True)
    plt.legend(loc="lower left")
    plt.tight_layout()
    plt.savefig(os.path.join(PLOTS_DIR, "ode_plot.png"), dpi=150)
    plt.close()
    
    print("ODE simulation done.")

# ----------------------------------------------------
# Main execution
# ----------------------------------------------------
if __name__ == "__main__":
    step_spline()
    step_least_squares()
    step_integration()
    step_ode()
    print("All simulations and plots generated successfully!")
