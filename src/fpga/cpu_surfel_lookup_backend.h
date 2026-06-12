#pragma once

#include "fpga/surfel_lookup_backend.h"

namespace lightning::fpga {

class CpuSurfelLookupBackend final : public SurfelLookupBackend {
   public:
    const char* Name() const override { return "LOOKUP_CPU_SIM"; }
    bool Lookup(const LookupBatchInput& input, LookupBatchOutput* output) override;
};

}  // namespace lightning::fpga
