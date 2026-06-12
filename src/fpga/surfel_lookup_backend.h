#pragma once

#include <string>

#include "fpga/fpga_lookup_types.h"

namespace lightning::fpga {

class SurfelLookupBackend {
   public:
    virtual ~SurfelLookupBackend() = default;

    virtual const char* Name() const = 0;
    virtual bool Lookup(const LookupBatchInput& input, LookupBatchOutput* output) = 0;
};

}  // namespace lightning::fpga
