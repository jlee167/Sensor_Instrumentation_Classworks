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
import numpy as np
import ok
from PIL import Image
from matplotlib import pyplot as plt
import time

import time
import sys

print("start")
dev = ok.okCFrontPanel()
dev.OpenBySerial("")

datain = bytearray(648*480)

while 1:
	dev.SetWireInValue(0x10, 0x0001)
	dev.UpdateWireIns()
	
	dev.SetWireInValue(0x10, 0x0000)
	dev.UpdateWireIns()
	
	dev.ReadFromBlockPipeOut(0xA3, 32, datain)
	image = Image.frombytes('L', (648, 480),bytes(datain))
	
	pix = np.array(image)
	plt.imshow(pix, cmap='gray')
	plt.pause(0.1)

"""
#%% 
# Next we open the device and program it
error_OpenBySerial = dev.OpenBySerial("")
error_ConfigureFpga = dev.ConfigureFPGA("pipeIn_PipeOut_framework.bit");

#%% 
# Display some diagnostic code
print("Open by Serial Error Code: " + str(error_OpenBySerial))
print("Configure FPGA Error Code: " + str(error_ConfigureFpga))
 
 
#%%
# WireOut Example
# Retrieve value on Wire endpoint with address 0x20,0x21
while 1:
	
	dev.SetWireInValue(0x03,0x00000001)
	dev.UpdateWireIns()
	dev.UpdateWireOuts()
	dataa = dev.GetWireOutValue(0x20)
	dev.SetWireInValue(0x00,dataa)
	dev.UpdateWireIns()
	datab = dev.GetWireOutValue(0x21)
	dev.SetWireInValue(0x03,0x00000000)
	dev.UpdateWireIns()
	
	buffer = bytearray(648*488)
	dev.ActivateTriggerIn(0x40,0)
	dev.ReadFromBlockPipeOut(0xa3,64,buffer)
	sys.stdout.flush()
	for x in range(0,1000):
		sys.stdout.write(format(buffer[x]))
		sys.stdout.flush()
	print('')
	
	#buffer = bytearray(16)
	#dev.ActivateTriggerIn(0x40,0)
	#dev.ReadFromBlockPipeOut(0xa3,16,buffer)
	#time.sleep(0.00001)

	#sys.stdout.write("Counter = 0x")


	"""