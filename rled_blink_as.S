###
# for GD32VF103
#
# from https://temofeev.ru/info/articles/izuchaem-risc-v-s-nulya-chast-1-assembler-i-soglasheniya/
#
# created and modfified 2022.11.15 by TGA
# last modified 2022.11.16 by TGA
# Compiling: 
# riscv64-unknown-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -nostdlib $1.S GD32VF103x8.lds -o $1.elf
# Flashing:
# stm32flash -v -g 0x0 /dev/ttyUSB0 -w $1.bin
###

###
# For RISC-V simulator "QtRVSim" 
# Directives to make interesting windows visible
#pragma qtrvsim show terminal
#pragma qtrvsim show registers
#pragma qtrvsim show memory
###

.globl _start
.globl __start
.option norelax

# #define BIT(x)                       ((uint32_t)((uint32_t)0x01U<<(x)))

# #define APB2_BUS_BASE         ((uint32_t)0x40010000U)        /*!< apb2 base address                */
# #define GPIO_BASE             (APB2_BUS_BASE + 0x00000800U)  /*!< GPIO base address                */
# /* GPIOx(x=A,B,C,D,E) definitions */
# #define GPIOA                      (GPIO_BASE + 0x00000000U)		// 0x40010800
# #define GPIOB                      (GPIO_BASE + 0x00000400U)		// 0x40010C00
# #define GPIOC                      (GPIO_BASE + 0x00000800U)		// 0x40011000
# #define GPIOD                      (GPIO_BASE + 0x00000C00U)		// 0x40011400
# #define GPIOE                      (GPIO_BASE + 0x00001000U)		// 0x40011800

# #define AHB1_BUS_BASE         ((uint32_t)0x40018000U)        /*!< ahb1 base address                */
# #define RCU_BASE              (AHB1_BUS_BASE + 0x00009000U)  /*!< RCU base address                 */	// 0x40021000
# /* RCU definitions */
# #define RCU                             RCU_BASE		// 0x40021000
# #define RCU_APB2EN                      REG32(RCU + 0x18U)        /*!< APB2 enable register */	// 0x40021018
# /* RCU_APB2EN */
# #define RCU_APB2EN_PBEN                 BIT(3)                    /*!< GPIO port B clock enable */
# #define RCU_APB2EN_PCEN                 BIT(4)                    /*!< GPIO port C clock enable */
# /* constants definitions */
# /* define the peripheral clock enable bit position and its register index offset */
# #define RCU_REGIDX_BIT(regidx, bitpos)      (((uint32_t)(regidx) << 6) | (uint32_t)(bitpos))
# #define RCU_REG_VAL(periph)                 (REG32(RCU + ((uint32_t)(periph) >> 6)))
# #define RCU_BIT_POS(val)                    ((uint32_t)(val) & 0x1FU)
# /* register offset */
# /* peripherals enable */
# #define AHBEN_REG_OFFSET                0x14U                     /*!< AHB enable register offset */
# #define APB1EN_REG_OFFSET               0x1CU                     /*!< APB1 enable register offset */
# #define APB2EN_REG_OFFSET               0x18U                     /*!< APB2 enable register offset */

#	RCU_GPIOB = RCU_REGIDX_BIT(APB2EN_REG_OFFSET, 3U),            /*!< GPIOC clock */	// 0x0600 | 4 = 0x0603
#	RCU_BIT_POS(RCU_GPIOB) = 0x03
# RCU_REG_VAL(RCU_GPIOB) |= BIT(RCU_BIT_POS(RCU_GPIOB));	// [0x40021018] = [0x40021018] | 0x08 = 
#	RCU_GPIOC = RCU_REGIDX_BIT(APB2EN_REG_OFFSET, 4U),            /*!< GPIOC clock */	// 0x0600 | 4 = 0x0604
#	RCU_BIT_POS(RCU_GPIOC) = 0x04
# RCU_REG_VAL(RCU_GPIOC) |= BIT(RCU_BIT_POS(RCU_GPIOC));	// [0x40021018] = [0x40021018] | 0x10 = 

# #define GPIO_PIN_13                     BIT(13)                   /*!< GPIO pin 13 */		// 
# /* GPIO mode definitions */
# #define GPIO_MODE_OUT_PP                 ((uint8_t)0x10U)          /*!< GPIO output with push-pull */
# /* GPIO output max speed value */
# #define GPIO_OSPEED_50MHZ                ((uint8_t)0x03U)          /*!< output max speed 50MHz */
# /* GPIO mode values set */
# #define GPIO_MODE_SET(n, mode)           ((uint32_t)((uint32_t)(mode) << (4U * (n))))
# #define GPIO_MODE_MASK(n)                (0xFU << (4U * (n)))
# GPIO_MODE_MASK(13 - 8) = 0x0F << (4*5) = 0xF00000
# GPIO_MODE_SET((13 - 8), 0x03) = 0x300000
# #define GPIO_BOP(gpiox)            REG32((gpiox) + 0x10U)    /*!< GPIO port bit operation register */
# #define GPIO_BC(gpiox)             REG32((gpiox) + 0x14U)    /*!< GPIO bit clear register */
# GPIO_BC(GPIOC) = 0x40011000 + 0x14 = 0x40011014

.equ RCU_APB2EN, 0x40021018
.equ RCU_APB2EN_PBEN, 0x08		# (1<<3)
.equ RCU_APB2EN_PCEN, 0x10		# (1<<4)
.equ GPIOB_CTL0, 0x40010C00		# for PB0 - PB7
.equ GPIOC_CTL0, 0x40011000		# for PC0 - PC7
.equ GPIOC_CTL1, 0x40011004		# for PC8 - PC15
.equ GPIO_MASK,  0x0F			# 0b1111
.equ GPIO_PP_50MHz, 0x03		# 0b0011
.equ GPIOB_OCTL, 0x40010C0C
.equ GPIOC_OCTL, 0x4001100C

#.equ RLED, 5		# PB5
.equ RLED, 13		# PC13 (Longan-nano)
.equ YLED, 6		# PB6
.equ GLED, 7		# PB7
.equ SBTN, 0		# PB0
.equ RBTN, 1		# PB1

# .org 0x07FEFFAC		// 0x08000000 - 0x00010054

.align 4

.text
#.global _start
_start:
	#rcu_periph_clock_enable(RCU_GPIOB) or rcu_periph_clock_enable(RCU_GPIOC)
	#RCU_APB2EN |= RCU_APB2EN_PBEN
	#RCU_APB2EN |= RCU_APB2EN_PCEN
	la   a5, RCU_APB2EN
	lw   a4, 0(a5)
	#ori  a4, a4, RCU_APB2EN_PBEN
	ori  a4, a4, RCU_APB2EN_PCEN
	sw   a4, 0(a5)

	#gpio_init(GPIOC, GPIO_MODE_OUT_PP, GPIO_OSPEED_50MHZ, GPIO_PIN_13);
	#GPIOB_CTL0 = (GPIOB_CTL0 & (0b1111<<RLED*4)) | 0b0011 << (RLED*4)
	#la   a5, GPIOB_CTL0		# for RLED < 8
	la   a5, GPIOC_CTL1			# for RLED >= 8
	lw   a4, 0(a5)
	# /* clear the specified pin mode bits */
	la   a6, ~0x00F00000		# ~(GPIO_MASK << ((RLED-8)*4)) (RLED-8) for RLED >= 8
	and  a3, a4, a6
	# /* set the specified pin mode bits */
	la   a4, 0x00300000			# (GPIO_PP_50MHz << ((RLED-8)*4)) (RLED-8) for RLED >= 8
	or   a4, a4, a3
	sw   a4, 0(a5)

MAIN_LOOP:
	#GPIO_OCTL(GPIOB) ^= (1<<RLED)
	#la   a5, GPIOB_OCTL
	la   a5, GPIOC_OCTL
	lw   a4, 0(a5)
	#xori a4, a4, 32			#(1<<RLED) RLED = 5 PB5
	#xori a4, a4, 0x2000		#(1<<RLED) RLED = 13 PC13
	la   a3, 0x2000
	xor  a4, a4, a3
	sw   a4, 0(a5)

	#sleep
	#la   a5, 200000
	#la   a5, 400000
	#la   a5, 800000
	la   a5, 1600000
	#la   a5, 20
sleep:
	addi a5, a5, -1
	bnez a5, sleep

	j    MAIN_LOOP

