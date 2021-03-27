// Include guard
#pragma once

// Tell compiler to retain function in object file, even if it is unreferenced.
#define EXPORTED __attribute__((visibility("default"))) __attribute__((used))

// Disable name mangling for C functions.
#ifdef __cplusplus
extern "C"
{
#endif

    // Return the version of this library.
    EXPORTED char *deepspeech_verison(void);

    // Free string allocated by DeepSpeech library.
    EXPORTED void deepspeech_free_str(char *string);

// Closing bracket for extern "C"
#ifdef __cplusplus
}
#endif