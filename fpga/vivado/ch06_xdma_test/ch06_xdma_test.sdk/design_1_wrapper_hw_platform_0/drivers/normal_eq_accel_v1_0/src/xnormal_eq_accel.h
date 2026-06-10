// ==============================================================
// File generated on Wed Jun 10 16:09:56 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XNORMAL_EQ_ACCEL_H
#define XNORMAL_EQ_ACCEL_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xnormal_eq_accel_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_BaseAddress;
} XNormal_eq_accel_Config;
#endif

typedef struct {
    u32 Control_BaseAddress;
    u32 IsReady;
} XNormal_eq_accel;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XNormal_eq_accel_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XNormal_eq_accel_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XNormal_eq_accel_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XNormal_eq_accel_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XNormal_eq_accel_Initialize(XNormal_eq_accel *InstancePtr, u16 DeviceId);
XNormal_eq_accel_Config* XNormal_eq_accel_LookupConfig(u16 DeviceId);
int XNormal_eq_accel_CfgInitialize(XNormal_eq_accel *InstancePtr, XNormal_eq_accel_Config *ConfigPtr);
#else
int XNormal_eq_accel_Initialize(XNormal_eq_accel *InstancePtr, const char* InstanceName);
int XNormal_eq_accel_Release(XNormal_eq_accel *InstancePtr);
#endif

void XNormal_eq_accel_Start(XNormal_eq_accel *InstancePtr);
u32 XNormal_eq_accel_IsDone(XNormal_eq_accel *InstancePtr);
u32 XNormal_eq_accel_IsIdle(XNormal_eq_accel *InstancePtr);
u32 XNormal_eq_accel_IsReady(XNormal_eq_accel *InstancePtr);
void XNormal_eq_accel_EnableAutoRestart(XNormal_eq_accel *InstancePtr);
void XNormal_eq_accel_DisableAutoRestart(XNormal_eq_accel *InstancePtr);

void XNormal_eq_accel_Set_input_r(XNormal_eq_accel *InstancePtr, u32 Data);
u32 XNormal_eq_accel_Get_input_r(XNormal_eq_accel *InstancePtr);
void XNormal_eq_accel_Set_output_r(XNormal_eq_accel *InstancePtr, u32 Data);
u32 XNormal_eq_accel_Get_output_r(XNormal_eq_accel *InstancePtr);
void XNormal_eq_accel_Set_num_points(XNormal_eq_accel *InstancePtr, u32 Data);
u32 XNormal_eq_accel_Get_num_points(XNormal_eq_accel *InstancePtr);

void XNormal_eq_accel_InterruptGlobalEnable(XNormal_eq_accel *InstancePtr);
void XNormal_eq_accel_InterruptGlobalDisable(XNormal_eq_accel *InstancePtr);
void XNormal_eq_accel_InterruptEnable(XNormal_eq_accel *InstancePtr, u32 Mask);
void XNormal_eq_accel_InterruptDisable(XNormal_eq_accel *InstancePtr, u32 Mask);
void XNormal_eq_accel_InterruptClear(XNormal_eq_accel *InstancePtr, u32 Mask);
u32 XNormal_eq_accel_InterruptGetEnabled(XNormal_eq_accel *InstancePtr);
u32 XNormal_eq_accel_InterruptGetStatus(XNormal_eq_accel *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
