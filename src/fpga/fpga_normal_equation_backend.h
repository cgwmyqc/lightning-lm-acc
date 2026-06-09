#pragma once

#include "fpga/normal_equation_backend.h"

namespace lightning::fpga {

class FpgaNormalEquationBackend final : public NormalEquationBackend {
   public:
    bool Accumulate(const std::vector<FpgaCorrInput>& corr, const NormalEquationState& state,
                    NormalEquationResult* result) override;
    std::string Name() const override { return "FPGA_STUB"; }
};

}  // namespace lightning::fpga
