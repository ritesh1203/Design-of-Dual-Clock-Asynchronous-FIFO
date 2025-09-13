# asynchronous_fifo

in this design all parts are desgin in different module. Here have two sunchronizer module for wrt synchronizer and read synchroniser. one fifo module one top module one module for full condition and one empty condition. And the testbench is written in system verilog. and also in verilog.

# contents

Introduction

FIFO structure

Architecture

Asynchronous FIFO Pointers

Synchronizers & Binary Gray Counter

Full & Empty Logic Block

outputs

simulation

# Introduction

FIFO-Every memory in which the data word that is written in first also comes out first when the memory is read is a first-in first-out memory.

An asynchronous FIFO refers to a FIFO design where data values are written sequentially into a FIFO buffer using one clock domain, and the data values are sequentially read from the same FIFO buffer using another clock domain, where the two clock domains are asynchronous to each other.

One common technique for designing an asynchronous FIFO is to use Gray code pointers that are synchronized into the opposite clock domain before generating synchronous FIFO full or empty status signals.


# FIFO Structure

<img width="832" height="423" alt="114535379-9c257180-9c6d-11eb-972d-fcfaf2aca1eb" src="https://github.com/user-attachments/assets/b97a0cd8-53ae-4fb5-b437-8aeec5af7138" />

# Architecture

<img width="865" height="532" alt="114535533-caa34c80-9c6d-11eb-8619-e6a7f10f8114" src="https://github.com/user-attachments/assets/0f433fc9-9ab3-4619-b997-27dff7c7ffb0" />


<img width="742" height="413" alt="111077783-6c713580-8518-11eb-83e7-8f8824ece83f" src="https://github.com/user-attachments/assets/e9c37161-1af8-4ad9-9f86-34ac4934eb59" />


# Asynchronous FIFO Pointers

The write pointer always points to the next word to be written; therefore, on reset, both pointers are set to zero, which also happens to be the next FIFO word location to be written

Read Pointer:

The read pointer always points to the current FIFO word to be read. The fact that the read pointer is always pointing to the next FIFO word to be read means that the receiver logic does not have to use two clock periods to read the data word.

Synchroniser using two flip flop

 <img width="763" height="216" alt="111077754-49468600-8518-11eb-9bfd-87d57d6dcd14" src="https://github.com/user-attachments/assets/9a5b9753-275e-49e3-b5e4-774ad9aada72" />


# Synchronizers & Binary Gray Counter

Synchronizers are very simple in operation; they are made of 2 D Flip Flop’s.As the FIFO is operating at 2 different clock domains so there is a need to synchronize the Write and Read pointers for generating empty and full logic which in turn is used for addressing the FIFO memory.

The Figure below shows how synchronization takes place; the logic behind this is very simple

<img width="435" height="266" alt="114535982-430a0d80-9c6e-11eb-8aa4-e6f910819907" src="https://github.com/user-attachments/assets/4b4b304e-bb83-4a34-b630-0b116bf5da3f" />

We need to design a counter which can give Binary and Gray output’s, the need for Binary counter is to address the FIFO MEMORY i.e. Write and Read address. And the need of Gray counter is for addressing Read and Write pointers.

# Full & Empty Logic Block

When the status counter reaches the maximum FIFO depth it will assert FIFO full signal and when its value is zero it will assert FIFO empty signal

<img width="533" height="268" alt="114536217-7b115080-9c6e-11eb-90d2-5df89f42e764" src="https://github.com/user-attachments/assets/4f4b0756-1606-4c9f-8721-3a86e2cbbc11" />

