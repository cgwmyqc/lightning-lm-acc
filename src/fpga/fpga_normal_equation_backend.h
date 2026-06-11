#pragma once

#include <cstdint>
#include <memory>
#include <string>

#include "fpga/normal_equation_backend.h"

namespace lightning::fpga {

class FpgaNormalEquationBackend final : public NormalEquationBackend {
   public:
    struct Options {
        std::string xdma_h2c = "/dev/xdma0_h2c_0";
        std::string xdma_c2h = "/dev/xdma0_c2h_0";
        std::string xdma_user = "/dev/xdma0_user";
        uint64_t normal_eq_ctrl_addr = 0x1000;
        uint64_t input_addr = 0x02000000;
        uint64_t output_addr = 0x02100000;
        int timeout_ms = 1000;
    };

    FpgaNormalEquationBackend();
    explicit FpgaNormalEquationBackend(Options options);
    ~FpgaNormalEquationBackend() override;

    bool Accumulate(const std::vector<FpgaCorrInput>& corr, const NormalEquationState& state,
                    NormalEquationResult* result) override;
    std::string Name() const override { return "FPGA"; }

   private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
};

}  // namespace lightning::fpga
