#include "fpga/fpga_normal_equation_backend.h"

namespace lightning::fpga {

bool FpgaNormalEquationBackend::Accumulate(const std::vector<FpgaCorrInput>&, const NormalEquationState&,
                                           NormalEquationResult*) {
    return false;
}

}  // namespace lightning::fpga
