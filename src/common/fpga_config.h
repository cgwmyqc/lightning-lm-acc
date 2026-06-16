// SPDX-License-Identifier: MIT
#pragma once

#include <string>

#include <yaml-cpp/yaml.h>

namespace lightning {

struct FpgaSubsystemConfig {
    bool global_enable = false;
    std::string global_mode = "cpu";
    bool enable = false;
    bool effective_enable = false;
    std::string mode = "cpu";
    std::string fallback = "cpu";
    bool used_legacy_flat = false;
};

std::string NormalizeFpgaMode(std::string mode);

FpgaSubsystemConfig LoadFpgaSubsystemConfig(const YAML::Node& yaml, const std::string& subsystem,
                                            const std::string& default_mode,
                                            const std::string& default_fallback,
                                            const std::string& legacy_prefix = "");

}  // namespace lightning
