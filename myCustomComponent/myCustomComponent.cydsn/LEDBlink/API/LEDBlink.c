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

#include "`$INSTANCE_NAME`.h"

uint8_t `$INSTANCE_NAME`_ReadStatus()
{
    return STATUS_`$INSTANCE_NAME`;
}
void `$INSTANCE_NAME`_WriteCtrl(uint8_t data)
{
    CONTROL_`$INSTANCE_NAME` = data;
}

void `$INSTANCE_NAME`_InitCount7 (void)
{
    uint8 interruptState;
    /* Enter critical section */
    interruptState = CyEnterCriticalSection();
    /* Set the Count Start bit */
    MYCOUNT7_AUX_CTL |= (1 << 5);
    /* Exit critical section */
    CyExitCriticalSection(interruptState);
}

/* [] END OF FILE */
