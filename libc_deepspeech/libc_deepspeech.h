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

    // Return pointer to loaded model state.
    EXPORTED void *create_model(char *model_path);

    // Free loaded model.
    EXPORTED void free_model(void *model_state);

    // Returns sample rate for loaded model
    EXPORTED uint64_t model_sample_rate(void *model_state);

    // Returns json output from speech to text engine.
    EXPORTED char *speech_to_text(void *model_state, char *buffer, uint64_t buffer_size);

    // Enable decoding using external scorer. Returns zero on success, non-zero on failure.
    EXPORTED int enable_external_scorer(void *model_state, char *scorer_file_path);

    // Disable decoding using external scorer. Returns zero on success, non-zero on failure.
    EXPORTED int disable_external_scorer(void *model_state);

    // Set hyperparameters alpha and beta of the external scorer. Returns zero on success, non-zero on failure.
    // @param alpha: The alpha hyperparameter of the decoder. Language model weight.
    // @param beta: The beta hyperparameter of the decoder. Word insertion weight.
    EXPORTED int set_scorer_alpha_beta(void *model_state, float alpha, float beta);


    // Closing bracket for extern "C"
#ifdef __cplusplus
}
#endif