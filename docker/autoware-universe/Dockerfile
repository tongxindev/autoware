ARG CUDA_IMAGE_TAG
FROM nvidia/cuda:$CUDA_IMAGE_TAG as devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

FROM devel as prebuilt
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
