# -*- coding: utf-8 -*-
"""
Created on Thu Sep  7 15:39:51 2017

@author: Eric Chen
"""

# -*- coding: utf-8 -*-
"""
ECE 437 - Sensors and Instrumentation
Spring 2016

Demonstrates basic OpalKelly functionality:
    - Connecting to devices
    - Configuring devices
    - WireIn communication
    - WireOut communication

@author: Brady Salz (salz2)
"""

#%%
# First we import the library and init the FrontPanel object
import numpy
import ok

from time import sleep

print("start")
dev = ok.okCFrontPanel()

#%% 
# Next we open the device and program it
a=dev.OpenBySerial("")
b=dev.ConfigureFPGA("pipeIn_PipeOut_framework.bit");

print(a);
print(b);

print("\nget")
	
size = 32;	
	
#datain = bytearray('00000000000000000000000000' , 'utf-8')
#buf = bytearray(size)
#dataout = bytearray('abcdefghijklmnopqrstuvwxyz', 'utf-8')
#dataout = bytearray([11], [23]
#datain = bytearray('00000000000000000000000000', 'utf-8')




datain = bytearray(16)
#dataout = bytearray(16)

#dataout = bytes([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F])

dataout = bytearray([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x00, 0x01, 0x02, 0x03])
data = dev.WriteToPipeIn(0x80, dataout)

#dataout = bytes([0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3])
#datain = bytes.fromhex('00000000000000000000000000')
#datain = bytearray([0x0000])
#datain = 0x0000000000000000
	
dev.SetWireInValue(0x10, 0x00000000)

	
dev.UpdateWireIns() #send

sleep(0.05) #sleep 50ms]


#data = dev.ReadFromPipeOut(0xA3, datain)
#data = dev.ReadFromPipeOut(0xA3, 10, datain)

# Send buffer to PipeIn endpoint with address 0x80
data = dev.WriteToPipeIn(0x80, dataout)
# Read to buffer from PipeOut endpoint with address 0xA0
data = dev.ReadFromPipeOut(0xA0, datain)





print(type(data))
print(data)
print(datain)

#print(bytes.toString(data))
	
