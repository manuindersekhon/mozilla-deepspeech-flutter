#include <stdlib.h>
#include <string>

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

void *create_model(char *model_path)
{
    if (model_path == NULL)
    {
        return NULL;
    }

    ModelState *ctx;
    int status = DS_CreateModel(model_path, &ctx);

    return (void *)ctx;
}

void free_model(void *model_state)
{
    if (model_state != NULL)
    {
        ModelState *ptr = (ModelState *)model_state;
        DS_FreeModel(ptr);
    }
}

uint64_t model_sample_rate(void *model_state)
{
    if (model_state == NULL)
    {
        return 0;
    }

    ModelState *ptr = (ModelState *)model_state;
    int sample_rate = DS_GetModelSampleRate(ptr);
    return sample_rate;
}

char *speech_to_text(void *model_state, char *buffer, uint64_t buffer_size)
{
    Metadata *result = DS_SpeechToTextWithMetadata((ModelState *)model_state, (short *)buffer, buffer_size / 2, 3);

    const CandidateTranscript *transcript = &result->transcripts[0];
    std::string retval = "";
    for (int i = 0; i < transcript->num_tokens; i++)
    {
        const TokenMetadata &token = transcript->tokens[i];
        retval += token.text;
    }
    char *encoded = strdup(retval.c_str());

    DS_FreeMetadata(result);

    return encoded;
}
