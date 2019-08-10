/* ========================================
 *
 * Copyright YOUR COMPANY, THE YEAR
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF your company.
 *
 * ========================================
*/
#ifndef LEDBLINK_H
#define LEDBLINK_H
    
#include <project.h>
    
#define STATUS_`$INSTANCE_NAME`     (* (reg8 *) `$INSTANCE_NAME`_StatusReg__STATUS_REG)
#define CONTROL_`$INSTANCE_NAME`    (* (reg8 *) `$INSTANCE_NAME`_ControlReg__CONTROL_REG)
#define MYCOUNT7_AUX_CTL            (* (reg8 *) `$INSTANCE_NAME`_Counter7__CONTROL_AUX_CTL_REG) 

uint8_t `$INSTANCE_NAME`_ReadStatus     (void);
void    `$INSTANCE_NAME`_WriteCtrl      (uint8_t data);
void    `$INSTANCE_NAME`_InitCount7     (void);

#endif /*LEDBLINK_H*/
/* [] END OF FILE */
