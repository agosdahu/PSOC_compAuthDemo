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
#include "project.h"

int main(void)
{
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    LEDBlink_InitCount7();
    UART_Start();

    for(;;)
    {
        /* Place your application code here. */
        static uint8_t tcCount      = 0;
        static uint8_t tcCountprev  = 99;
        static uint8_t stateCnt     = 0;
        
        tcCount = LEDBlink_ReadStatus();
        
        if(tcCount != tcCountprev)
        {
            UART_PutChar(tcCount);
            tcCountprev = tcCount;
            stateCnt++;
        }
        
        if(stateCnt >= 10)
        {
            static uint8_t state = 0;
            
            switch(state)
            {
                case 0: LEDBlink_WriteCtrl(25); break;
                case 1: LEDBlink_WriteCtrl(50); break;
                case 2: LEDBlink_WriteCtrl(75); break;
            }
            
            state = (state + 1) % 3;
            stateCnt = 0;
        }
        
        
    }
}

/* [] END OF FILE */
