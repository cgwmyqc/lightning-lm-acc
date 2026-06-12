#pragma once

#include <cstdint>
#include <filesystem>
#include <string>

#include "core/block_surfel_map/block_surfel_map.h"
#include "fpga/fpga_lookup_types.h"

namespace lightning::fpga {

class FpgaLookupGoldenWriter {
   public:
    struct Options {
        bool enable = false;
        std::string dump_dir = "/tmp/lightning_fpga_lookup_golden";
        int every_n_frames = 100;
        int max_files = 50;
    };

    explicit FpgaLookupGoldenWriter(Options options);

    bool MaybeWrite(uint32_t frame_id, const LookupBatchInput& input, const LookupBatchOutput& cpu_output,
                    const SurfelLookupStats& stats);

   private:
    bool ShouldWrite(uint32_t frame_id) const;
    void PruneOldFiles() const;
    std::filesystem::path MakePath(uint32_t frame_id) const;

    Options options_;
};

}  // namespace lightning::fpga
