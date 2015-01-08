// CircularBufferArray.h

#ifndef CIRCULARBUFFERARRAY_H
#define CIRCULARBUFFERARRAY_H

#endif  // CIRCULARBUFFERARRAY_H

#include "stdincludes.h"


#define CBA_ARRAY_SIZE 10

typedef struct
{
    UINT16 firstIndex;
    UINT16 maxIndex;
    UINT8  array[CBA_ARRAY_SIZE]; // Twice the space to store the array

}CircularBufferArray_t;

// Functions
void cba_init(CircularBufferArray_t myCBA);
void cba_add(CircularBufferArray_t myCBA, UINT8 num);
UINT8 cba_get(CircularBufferArray_t myCBA, UINT16 idx);
