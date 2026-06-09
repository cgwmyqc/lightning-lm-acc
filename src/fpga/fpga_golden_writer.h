#pragma once

#include <cstdint>
#include <filesystem>
#include <string>
#include <vector>

#include "fpga/normal_equation_backend.h"

namespace lightning::fpga {

class FpgaGoldenWriter {
   public:
    struct Options {
        bool enable = false;
        std::string dump_dir = "/tmp/lightning_fpga_golden";
        int every_n_frames = 100;
        int max_files = 50;
    };

    explicit FpgaGoldenWriter(Options options);

    bool MaybeWrite(uint32_t frame_id, const NormalEquationState& state, const std::vector<FpgaCorrInput>& corr,
                    const NormalEquationResult& cpu_result);

   private:
    bool ShouldWrite(uint32_t frame_id) const;
    void PruneOldFiles() const;
    std::filesystem::path MakePath(uint32_t frame_id) const;

    Options options_;
};

}  // namespace lightning::fpga
