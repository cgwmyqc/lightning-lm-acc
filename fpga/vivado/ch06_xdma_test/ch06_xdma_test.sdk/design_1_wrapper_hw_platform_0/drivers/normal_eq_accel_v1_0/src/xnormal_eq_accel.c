// ==============================================================
// File generated on Wed Jun 10 16:09:56 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xnormal_eq_accel.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XNormal_eq_accel_CfgInitialize(XNormal_eq_accel *InstancePtr, XNormal_eq_accel_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XNormal_eq_accel_Start(XNormal_eq_accel *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_AP_CTRL) & 0x80;
    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XNormal_eq_accel_IsDone(XNormal_eq_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XNormal_eq_accel_IsIdle(XNormal_eq_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XNormal_eq_accel_IsReady(XNormal_eq_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XNormal_eq_accel_EnableAutoRestart(XNormal_eq_accel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XNormal_eq_accel_DisableAutoRestart(XNormal_eq_accel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_AP_CTRL, 0);
}

void XNormal_eq_accel_Set_input_r(XNormal_eq_accel *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_INPUT_R_DATA, Data);
}

u32 XNormal_eq_accel_Get_input_r(XNormal_eq_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_INPUT_R_DATA);
    return Data;
}

void XNormal_eq_accel_Set_output_r(XNormal_eq_accel *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_OUTPUT_R_DATA, Data);
}

u32 XNormal_eq_accel_Get_output_r(XNormal_eq_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_OUTPUT_R_DATA);
    return Data;
}

void XNormal_eq_accel_Set_num_points(XNormal_eq_accel *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_NUM_POINTS_DATA, Data);
}

u32 XNormal_eq_accel_Get_num_points(XNormal_eq_accel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_NUM_POINTS_DATA);
    return Data;
}

void XNormal_eq_accel_InterruptGlobalEnable(XNormal_eq_accel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_GIE, 1);
}

void XNormal_eq_accel_InterruptGlobalDisable(XNormal_eq_accel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_GIE, 0);
}

void XNormal_eq_accel_InterruptEnable(XNormal_eq_accel *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_IER);
    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_IER, Register | Mask);
}

void XNormal_eq_accel_InterruptDisable(XNormal_eq_accel *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_IER);
    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_IER, Register & (~Mask));
}

void XNormal_eq_accel_InterruptClear(XNormal_eq_accel *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XNormal_eq_accel_WriteReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_ISR, Mask);
}

u32 XNormal_eq_accel_InterruptGetEnabled(XNormal_eq_accel *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_IER);
}

u32 XNormal_eq_accel_InterruptGetStatus(XNormal_eq_accel *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XNormal_eq_accel_ReadReg(InstancePtr->Control_BaseAddress, XNORMAL_EQ_ACCEL_CONTROL_ADDR_ISR);
}

