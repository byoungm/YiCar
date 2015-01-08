// CircularBufferArray.c

#include "CircularBufferArray.h"




void cba_init(CircularBufferArray_t myCBA)
{
    myCBA.maxIndex = (CBA_ARRAY_SIZE - 1);
    myCBA.firstIndex = myCBA.maxIndex;
}

void cba_add(CircularBufferArray_t myCBA, UINT8 num)
{
    myCBA.firstIndex = (myCBA.firstIndex == 0) ? myCBA.maxIndex : myCBA.firstIndex-1;
    myCBA.array[myCBA.firstIndex] = num;

    // Debug only
    if (myCBA.firstIndex == 1)
    {
        PORTBbits.RB4 = 1; // DEBUG STOP HERE
        PORTBbits.RB4 = 1; // DEBUG STOP HERE
    }
}

UINT8 cba_get(CircularBufferArray_t myCBA, UINT16 idx)
{
    UINT16 realIndex = 0;
    realIndex = idx + myCBA.firstIndex;
    realIndex = ( realIndex > myCBA.maxIndex ) ? realIndex - myCBA.maxIndex : realIndex;

    return myCBA.array[realIndex];
}