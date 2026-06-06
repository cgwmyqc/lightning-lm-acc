// ==============================================================
// File generated on Fri May 22 14:09:46 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xsimple_accel_core.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XSimple_accel_core_CfgInitialize(XSimple_accel_core *InstancePtr, XSimple_accel_core_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XSimple_accel_core_Start(XSimple_accel_core *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_AP_CTRL) & 0x80;
    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XSimple_accel_core_IsDone(XSimple_accel_core *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XSimple_accel_core_IsIdle(XSimple_accel_core *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XSimple_accel_core_IsReady(XSimple_accel_core *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XSimple_accel_core_EnableAutoRestart(XSimple_accel_core *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XSimple_accel_core_DisableAutoRestart(XSimple_accel_core *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_AP_CTRL, 0);
}

void XSimple_accel_core_Set_in_buf(XSimple_accel_core *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_IN_BUF_DATA, Data);
}

u32 XSimple_accel_core_Get_in_buf(XSimple_accel_core *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_IN_BUF_DATA);
    return Data;
}

void XSimple_accel_core_Set_out_buf(XSimple_accel_core *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_OUT_BUF_DATA, Data);
}

u32 XSimple_accel_core_Get_out_buf(XSimple_accel_core *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_OUT_BUF_DATA);
    return Data;
}

void XSimple_accel_core_Set_num_items(XSimple_accel_core *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_NUM_ITEMS_DATA, Data);
}

u32 XSimple_accel_core_Get_num_items(XSimple_accel_core *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_NUM_ITEMS_DATA);
    return Data;
}

void XSimple_accel_core_InterruptGlobalEnable(XSimple_accel_core *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_GIE, 1);
}

void XSimple_accel_core_InterruptGlobalDisable(XSimple_accel_core *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_GIE, 0);
}

void XSimple_accel_core_InterruptEnable(XSimple_accel_core *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_IER);
    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_IER, Register | Mask);
}

void XSimple_accel_core_InterruptDisable(XSimple_accel_core *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_IER);
    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_IER, Register & (~Mask));
}

void XSimple_accel_core_InterruptClear(XSimple_accel_core *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSimple_accel_core_WriteReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_ISR, Mask);
}

u32 XSimple_accel_core_InterruptGetEnabled(XSimple_accel_core *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_IER);
}

u32 XSimple_accel_core_InterruptGetStatus(XSimple_accel_core *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSimple_accel_core_ReadReg(InstancePtr->Control_BaseAddress, XSIMPLE_ACCEL_CORE_CONTROL_ADDR_ISR);
}

