# RISC_V_UART

This repository contains the RISC-V single cycle interfaced with UART module using Memory-mapped I/O technique

RISC-V processor is implemented using https://github.com/Hafsa1918/RISC_V repository whereas UART module is implemented using https://github.com/MuhammadMajiid/UART repository

0x60 is considered base address for UART communication 

Using address 0x60 for TX data register
      address 0x61 for Control register
      address 0x62 for Status register
      address 0x63 for RX data register



# RTL design
The following image illustrates the connections between processor and UART module using memory-mapped I/O

![Screenshot 2024-09-30 223848](https://github.com/user-attachments/assets/ca77b327-3606-41c0-a90a-f7bb4cae76b1)


# Instructions used

    **Addr	    Machine Code	    Basic Code	     Original Code	**

    0x00	      0x03c00d93	      addi x27 x0 60	      addi x27, x0, 60 #base address

    0x04	      0x0aa00e13	      addi x28 x0 170	      addi x28, x0, 0x000000AA #data written to a temp register

    0x08	      0x00c00e93	      addi x29 x0 12    	  addi x29, x0, 0x0000000C #control register value initialized in a temp register

    0x0c     0x02000b93    	  addi x23 x0 32    	  addi x23,x0,0x20 # TX DONE FLAG 

    0x10	      0x01dd80a3    	  sb x29 1(x27)	        sb x29, 1(x27)         # control register is initialized

    0x14	      0x01cd8023	      sb x28 0(x27)	        sb x28, 0(x27)         # TX data register is initialized

    0x18	      0x001e8e93    	  addi x29 x29 1    	  addi x29,x29,1            # send signal = 1

    0x1c	      0x01dd80a3	      sb x29 1(x27)    	    sb x29, 1(x27)          # Transmission is enabled

    0x20	      0x002d8f03    	  lb x30 2(x27)	        tx_wait: lb x30, 2(x27)   # Status register is read to check for transmission completion status

    0x24	      0x01ebf333	      and x6 x23 x30    	  and x6,x23,x30

    0x28	      0xff731ce3    	  bne x6 x23 -8	        bne x6,x23, tx_wait      

    0x2c	      0x00800b93	      addi x23 x0 8	        addi x23, x0, 0x08       # initializing RX DONE FLAG in a temp register

    0x30	      0x002d8f03	      lb x30 2(x27)	        rx_wait: lb x30, 2(x27)      # Again reading status register to check for data receptino status

    0x34	      0x01ebf333    	  and x6 x23 x30    	  and x6,x23,x30

    0x38	      0xff731ce3	      bne x6 x23 -8	        bne x6,x23, rx_wait

    0x3c	      0x003d8f83	      lb x31 3(x27)	        lb x31,3(x27)                # reading received data


# Simulation Results

The complete project is simulated on Modelsim.

At time 0 instance
![Screenshot 2024-09-30 223333](https://github.com/user-attachments/assets/5d7ebabd-8f1f-4f23-ac17-d698ce60b076)


While data (10101010) is being transmitted and received
![Screenshot 2024-09-30 223519](https://github.com/user-attachments/assets/3838ec3c-cb2f-4f37-a10a-b2978b1e9aef)


Received byte is saved in register x31 as per last instruction
![Screenshot 2024-09-30 223640](https://github.com/user-attachments/assets/1986dcc8-0e8d-4ca6-a6ac-c7c00911a119)


