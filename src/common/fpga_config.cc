// SPDX-License-Identifier: MIT

#include "common/fpga_config.h"

#include <algorithm>
#include <cctype>

namespace lightning {
namespace {

template <typename T>
T GetYamlValue(const YAML::Node& node, const std::string& key, const T& default_value) {
    if (node && node[key]) {
        return node[key].as<T>();
    }
    return default_value;
}

}  // namespace

std::string NormalizeFpgaMode(std::string mode) {
    std::transform(mode.begin(), mode.end(), mode.begin(), [](unsigned char c) {
        if (c == '-') {
            return '_';
        }
        return static_cast<char>(std::tolower(c));
    });
    return mode.empty() ? std::string("cpu") : mode;
}

FpgaSubsystemConfig LoadFpgaSubsystemConfig(const YAML::Node& yaml, const std::string& subsystem,
                                            const std::string& default_mode,
                                            const std::string& default_fallback,
                                            const std::string& legacy_prefix) {
    FpgaSubsystemConfig config;
    const YAML::Node fpga = yaml["fpga"];
    const YAML::Node subsystem_node = fpga ? fpga[subsystem] : YAML::Node();

    config.global_enable = GetYamlValue(fpga, "enable", false);
    config.global_mode = NormalizeFpgaMode(GetYamlValue(fpga, "mode", default_mode));
    config.mode = NormalizeFpgaMode(GetYamlValue(subsystem_node, "mode", config.global_mode));
    config.fallback = NormalizeFpgaMode(GetYamlValue(subsystem_node, "fallback", default_fallback));
    config.enable = GetYamlValue(subsystem_node, "enable", false);

    if (!subsystem_node && !legacy_prefix.empty() && fpga) {
        const std::string legacy_enable_key = legacy_prefix + "_enable";
        const std::string legacy_mode_key = legacy_prefix + "_mode";
        const std::string legacy_fallback_key = legacy_prefix + "_fallback";
        if (fpga[legacy_enable_key] || fpga[legacy_mode_key] || fpga[legacy_fallback_key]) {
            config.used_legacy_flat = true;
            config.enable = GetYamlValue(fpga, legacy_enable_key, config.enable);
            config.mode = NormalizeFpgaMode(GetYamlValue(fpga, legacy_mode_key, config.mode));
            config.fallback = NormalizeFpgaMode(GetYamlValue(fpga, legacy_fallback_key, config.fallback));
        }
    }

    config.effective_enable = config.global_enable && config.enable;
    return config;
}

}  // namespace lightning
