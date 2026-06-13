// ==============================================================
// File generated on Sat Jun 13 15:54:10 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xlookup_batch_accel.h"

extern XLookup_batch_accel_Config XLookup_batch_accel_ConfigTable[];

XLookup_batch_accel_Config *XLookup_batch_accel_LookupConfig(u16 DeviceId) {
	XLookup_batch_accel_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XLOOKUP_BATCH_ACCEL_NUM_INSTANCES; Index++) {
		if (XLookup_batch_accel_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XLookup_batch_accel_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XLookup_batch_accel_Initialize(XLookup_batch_accel *InstancePtr, u16 DeviceId) {
	XLookup_batch_accel_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XLookup_batch_accel_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XLookup_batch_accel_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

