// ==============================================================
// File generated on Fri May 22 14:09:46 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xsimple_accel_core.h"

extern XSimple_accel_core_Config XSimple_accel_core_ConfigTable[];

XSimple_accel_core_Config *XSimple_accel_core_LookupConfig(u16 DeviceId) {
	XSimple_accel_core_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSIMPLE_ACCEL_CORE_NUM_INSTANCES; Index++) {
		if (XSimple_accel_core_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XSimple_accel_core_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSimple_accel_core_Initialize(XSimple_accel_core *InstancePtr, u16 DeviceId) {
	XSimple_accel_core_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSimple_accel_core_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSimple_accel_core_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

