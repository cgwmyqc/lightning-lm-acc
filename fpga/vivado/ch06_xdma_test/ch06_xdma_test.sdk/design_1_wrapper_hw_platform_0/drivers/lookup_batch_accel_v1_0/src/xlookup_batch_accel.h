// ==============================================================
// File generated on Sat Jun 13 15:54:10 +0800 2026
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XLOOKUP_BATCH_ACCEL_H
#define XLOOKUP_BATCH_ACCEL_H

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
#include "xlookup_batch_accel_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_BaseAddress;
} XLookup_batch_accel_Config;
#endif

typedef struct {
    u32 Control_BaseAddress;
    u32 IsReady;
} XLookup_batch_accel;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XLookup_batch_accel_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XLookup_batch_accel_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XLookup_batch_accel_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XLookup_batch_accel_ReadReg(BaseAddress, RegOffset) \
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
int XLookup_batch_accel_Initialize(XLookup_batch_accel *InstancePtr, u16 DeviceId);
XLookup_batch_accel_Config* XLookup_batch_accel_LookupConfig(u16 DeviceId);
int XLookup_batch_accel_CfgInitialize(XLookup_batch_accel *InstancePtr, XLookup_batch_accel_Config *ConfigPtr);
#else
int XLookup_batch_accel_Initialize(XLookup_batch_accel *InstancePtr, const char* InstanceName);
int XLookup_batch_accel_Release(XLookup_batch_accel *InstancePtr);
#endif

void XLookup_batch_accel_Start(XLookup_batch_accel *InstancePtr);
u32 XLookup_batch_accel_IsDone(XLookup_batch_accel *InstancePtr);
u32 XLookup_batch_accel_IsIdle(XLookup_batch_accel *InstancePtr);
u32 XLookup_batch_accel_IsReady(XLookup_batch_accel *InstancePtr);
void XLookup_batch_accel_EnableAutoRestart(XLookup_batch_accel *InstancePtr);
void XLookup_batch_accel_DisableAutoRestart(XLookup_batch_accel *InstancePtr);

void XLookup_batch_accel_Set_input_r(XLookup_batch_accel *InstancePtr, u32 Data);
u32 XLookup_batch_accel_Get_input_r(XLookup_batch_accel *InstancePtr);
void XLookup_batch_accel_Set_output_r(XLookup_batch_accel *InstancePtr, u32 Data);
u32 XLookup_batch_accel_Get_output_r(XLookup_batch_accel *InstancePtr);
void XLookup_batch_accel_Set_num_points(XLookup_batch_accel *InstancePtr, u32 Data);
u32 XLookup_batch_accel_Get_num_points(XLookup_batch_accel *InstancePtr);
void XLookup_batch_accel_Set_num_blocks(XLookup_batch_accel *InstancePtr, u32 Data);
u32 XLookup_batch_accel_Get_num_blocks(XLookup_batch_accel *InstancePtr);

void XLookup_batch_accel_InterruptGlobalEnable(XLookup_batch_accel *InstancePtr);
void XLookup_batch_accel_InterruptGlobalDisable(XLookup_batch_accel *InstancePtr);
void XLookup_batch_accel_InterruptEnable(XLookup_batch_accel *InstancePtr, u32 Mask);
void XLookup_batch_accel_InterruptDisable(XLookup_batch_accel *InstancePtr, u32 Mask);
void XLookup_batch_accel_InterruptClear(XLookup_batch_accel *InstancePtr, u32 Mask);
u32 XLookup_batch_accel_InterruptGetEnabled(XLookup_batch_accel *InstancePtr);
u32 XLookup_batch_accel_InterruptGetStatus(XLookup_batch_accel *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
