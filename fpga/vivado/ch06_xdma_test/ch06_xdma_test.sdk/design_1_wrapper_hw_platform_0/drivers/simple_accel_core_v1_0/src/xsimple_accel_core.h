// ==============================================================
// File generated on Fri May 22 14:09:46 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XSIMPLE_ACCEL_CORE_H
#define XSIMPLE_ACCEL_CORE_H

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
#include "xsimple_accel_core_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_BaseAddress;
} XSimple_accel_core_Config;
#endif

typedef struct {
    u32 Control_BaseAddress;
    u32 IsReady;
} XSimple_accel_core;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XSimple_accel_core_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XSimple_accel_core_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XSimple_accel_core_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XSimple_accel_core_ReadReg(BaseAddress, RegOffset) \
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
int XSimple_accel_core_Initialize(XSimple_accel_core *InstancePtr, u16 DeviceId);
XSimple_accel_core_Config* XSimple_accel_core_LookupConfig(u16 DeviceId);
int XSimple_accel_core_CfgInitialize(XSimple_accel_core *InstancePtr, XSimple_accel_core_Config *ConfigPtr);
#else
int XSimple_accel_core_Initialize(XSimple_accel_core *InstancePtr, const char* InstanceName);
int XSimple_accel_core_Release(XSimple_accel_core *InstancePtr);
#endif

void XSimple_accel_core_Start(XSimple_accel_core *InstancePtr);
u32 XSimple_accel_core_IsDone(XSimple_accel_core *InstancePtr);
u32 XSimple_accel_core_IsIdle(XSimple_accel_core *InstancePtr);
u32 XSimple_accel_core_IsReady(XSimple_accel_core *InstancePtr);
void XSimple_accel_core_EnableAutoRestart(XSimple_accel_core *InstancePtr);
void XSimple_accel_core_DisableAutoRestart(XSimple_accel_core *InstancePtr);

void XSimple_accel_core_Set_in_buf(XSimple_accel_core *InstancePtr, u32 Data);
u32 XSimple_accel_core_Get_in_buf(XSimple_accel_core *InstancePtr);
void XSimple_accel_core_Set_out_buf(XSimple_accel_core *InstancePtr, u32 Data);
u32 XSimple_accel_core_Get_out_buf(XSimple_accel_core *InstancePtr);
void XSimple_accel_core_Set_num_items(XSimple_accel_core *InstancePtr, u32 Data);
u32 XSimple_accel_core_Get_num_items(XSimple_accel_core *InstancePtr);

void XSimple_accel_core_InterruptGlobalEnable(XSimple_accel_core *InstancePtr);
void XSimple_accel_core_InterruptGlobalDisable(XSimple_accel_core *InstancePtr);
void XSimple_accel_core_InterruptEnable(XSimple_accel_core *InstancePtr, u32 Mask);
void XSimple_accel_core_InterruptDisable(XSimple_accel_core *InstancePtr, u32 Mask);
void XSimple_accel_core_InterruptClear(XSimple_accel_core *InstancePtr, u32 Mask);
u32 XSimple_accel_core_InterruptGetEnabled(XSimple_accel_core *InstancePtr);
u32 XSimple_accel_core_InterruptGetStatus(XSimple_accel_core *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
