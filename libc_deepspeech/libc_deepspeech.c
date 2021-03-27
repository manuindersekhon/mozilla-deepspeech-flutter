#include <stdlib.h>

// Deepspeech 0.9.3 library header file.
#include "../libdeepspeech_0.9.3/deepspeech.h"

// This library header file.
#include "libc_deepspeech.h"

char *deepspeech_verison(void)
{
    char *version = DS_Version();
    return version;
}

void deepspeech_free_str(char *string)
{
    if (string != NULL)
    {
        DS_FreeString(string);
    }
}