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


 
