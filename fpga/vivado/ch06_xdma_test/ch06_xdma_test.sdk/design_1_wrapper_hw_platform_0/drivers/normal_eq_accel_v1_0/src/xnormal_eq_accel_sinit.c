// ==============================================================
// File generated on Wed Jun 10 16:09:56 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xnormal_eq_accel.h"

extern XNormal_eq_accel_Config XNormal_eq_accel_ConfigTable[];

XNormal_eq_accel_Config *XNormal_eq_accel_LookupConfig(u16 DeviceId) {
	XNormal_eq_accel_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XNORMAL_EQ_ACCEL_NUM_INSTANCES; Index++) {
		if (XNormal_eq_accel_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XNormal_eq_accel_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XNormal_eq_accel_Initialize(XNormal_eq_accel *InstancePtr, u16 DeviceId) {
	XNormal_eq_accel_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XNormal_eq_accel_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XNormal_eq_accel_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

