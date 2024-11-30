# 介绍

设计了一个基于CORDIC算法的三角函数计算器，可以通过该计算器计算$[0,2\pi]$定义域的`sin`和`cos`值，可以通过拨码开关输入计算角度并通过数码管显示，也可以通过`PS2`接口的键盘进行输入并通过`VGA`接口的显示屏显示。

## 1.功能说明

1. 完成一个CORDIC算法的三角函数`sin`和`cos`计算器硬件设计；

2. 使用12个拨码开关按BCD码编码输入待计算角度（$0-360°$）；

3. 使用1个拨码开关实现正余弦功能选择；
4. 一个按键作为计算启动开关；
5. 计算结果通过四个数码管的显示；
6. 时钟信号为开发板上时钟信号；
7. 集成PS2和VGA显示器，使用PS2输入待计算值，在VGA显示器上显示待计算值和输出操作结果。

## 2.工程文件说明

- `./Cordic_calculate_base`：

  1. 完成一个CORDIC算法的三角函数`sin`和`cos`计算器硬件设计

  2. 使用12个拨码开关按BCD码编码输入待计算角度（$0-180°$）

  3. 使用1个拨码开关实现正余弦功能选择

  3. 一个按键作为计算启动开关

  3. 计算结果通过四个数码管的显示

- `./Cordic_calculate_expand`：
  - 相比`./Cordic_calculate_base`，计算角度扩展到$0-360°$

- `./Cordic_calculate_vga`：
  - 相比`./Cordic_calculate_expand`，增加了VGA显示功能
- `./Cordic_calculate_ps2`:
  - 相比`./Cordic_calculate_vga`，增加了PS2键盘输入功能

## 3.RTL设计结构

![image-20241130141635480](https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301416708.png)

- `keyBoard`模块：处理PS2接口模块的时序
- `keyBoard_state`模块：处理keyBoard的输入，判断输入的是个位数、十位数还是百位数，并且判断键盘输入的开始信号
- `bcd2bin`模块：主要是将键盘输入组合成的bcd码转换成bin格式，用于接下来的cordic计算
- `cordic_sin_cos`模块：用于计算输入的angle[11:0]的sin值和cos值
- `int2float`模块：将cordic输出的sin值和cos值转换成浮点数的形式
- `bin2bcd_54bits`模块：将int2float模块输出的sin和cos值转换成bcd值，以便后续的数码管和VGA显示屏的显示
- `clk_div`模块：将主时钟进行四分频，由100MHz变为25MHz，用于VGA_640_480模块时序的时钟
- `display`模块：控制数码管显示计算出来的sin和cos值
- `vga_initials`模块：根据`bin2bcd_54bits`模块输出的bcd码决定VGA显示屏要显示什么

## 4.功能验证

验证`cordic_sin_cos`模块输出的值是否正确，验证VGA显示器显示的值是否正确。

**验证环境：**

**软件**：vivado2018.3、ModelSim SE2020.4

**硬件**：basys3开发板、VGA显示器、PS2键盘

## 4.1 激励和仿真结果

**激励**：

<img src="https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301422807.png" alt="image-20241130142227697" style="zoom:50%;" />

**仿真结果**：

![image-20241130142313344](https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301423410.png)

![image-20241130142321832](https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301423948.png)

## 4.2 FPGA验证

先用键盘输入想要计算的角度数值，键盘先输入百位数，按一下回车键，再输入十位数，按一下回车键，再输入个位数，再按一次下回车键，这样角度的输入就完成了，此时会在数码管和VGA显示屏同时显示`sin`或`cos`的值，拨动拨码开关`sin`和`cos`结果切换显示。

**输入123**：

<img src="https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301425090.png" alt="image-20241130142516965" style="zoom:50%;" />

**显示`sin`值：**

<img src="https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301425962.png" alt="image-20241130142541763" style="zoom:50%;" />

**显示`cos`值：**

<img src="https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301427834.png" alt="image-20241130142701675" style="zoom:50%;" />

# Introduction

A trigonometric function calculator based on the CORDIC algorithm has been designed. This calculator can compute the `sin` and `cos` values for angles in the range $[0, 2\pi]$. The angle can be input using either a DIP switch or a PS2 keyboard and the results are displayed on a 7-segment display or on a VGA screen.

## 1. Function Description

1. Design and implement hardware for a CORDIC-based trigonometric function calculator to compute `sin` and `cos`.
2. Use 12 DIP switches to input the angle in BCD encoding for calculation ($0^\circ$ to $360^\circ$).
3. Use a DIP switch to select between `sin` and `cos` functions.
4. One button is used to start the calculation.
5. Display the result on four 7-segment displays.
6. The clock signal is provided by the development board’s clock.
7. Integrate PS2 and VGA displays. The PS2 keyboard is used for inputting the angle, while the VGA display shows the input angle and the calculated results.

## 2. Project File Descriptions

- `./Cordic_calculate_base`:
  1. Implements a CORDIC algorithm-based trigonometric function calculator for `sin` and `cos`.
  2. Uses 12 DIP switches to input the angle in BCD encoding ($0^\circ$ to $180^\circ$).
  3. Implements a DIP switch to select between `sin` and `cos` functions.
  4. Uses a button to start the calculation.
  5. Displays the results on four 7-segment displays.
- `./Cordic_calculate_expand`:
  - Expands the calculation angle range to $0^\circ$ to $360^\circ$ compared to `./Cordic_calculate_base`.
- `./Cordic_calculate_vga`:
  - Adds VGA display functionality compared to `./Cordic_calculate_expand`.
- `./Cordic_calculate_ps2`:
  - Adds PS2 keyboard input functionality compared to `./Cordic_calculate_vga`.

## 3. RTL Design Structure

![RTL Design Structure](https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301416708.png)

- `keyBoard` module: Handles the timing of the PS2 interface module.
- `keyBoard_state` module: Processes input from the keyboard, determines whether the input corresponds to ones, tens, or hundreds digits, and detects the start signal.
- `bcd2bin` module: Converts the BCD code generated from the keyboard input into binary format for CORDIC computation.
- `cordic_sin_cos` module: Computes the `sin` and `cos` values for the input angle `[11:0]`.
- `int2float` module: Converts the `sin` and `cos` values output by CORDIC to floating-point format.
- `bin2bcd_54bits` module: Converts the floating-point `sin` and `cos` values to BCD format for display on the 7-segment display and VGA screen.
- `clk_div` module: Divides the main clock signal by 4, changing it from 100MHz to 25MHz for the VGA timing module.
- `display` module: Controls the display of the computed `sin` and `cos` values on the 7-segment displays.
- `vga_initials` module: Decides what to display on the VGA screen based on the BCD output from the `bin2bcd_54bits` module.

## 4. Functional Verification

Verify the correctness of the output values from the `cordic_sin_cos` module and the display values on the VGA screen.

**Verification Environment:**

- **Software**: Vivado 2018.3, ModelSim SE2020.4
- **Hardware**: Basys3 development board, VGA monitor, PS2 keyboard

## 4.1 Stimulus and Simulation Results

**Stimulus**:

<img src="https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301422807.png" alt="Stimulus" style="zoom:50%;" />

**Simulation Results**:

![Simulation Result 1](https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301423410.png)

![Simulation Result 2](https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301423948.png)

## 4.2 FPGA Verification

First, use the keyboard to input the angle to be calculated. The keyboard inputs the hundreds digit first, followed by pressing the Enter key, then the tens digit, pressing Enter again, and finally the ones digit, followed by pressing Enter again to complete the angle input. At this point, the `sin` or `cos` values will be displayed on both the 7-segment display and the VGA screen. Toggle the DIP switch to switch between displaying the `sin` or `cos` result.

**Input 123**:

<img src="https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301425090.png" alt="Input 123" style="zoom:50%;" />

**Display `sin` value**:

<img src="https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301425962.png" alt="Display sin value" style="zoom:50%;" />

**Display `cos` value**:

<img src="https://cdn.jsdelivr.net/gh/xiaodiao188/blog-img@img/img/202411301427834.png" alt="Display cos value" style="zoom:50%;" />