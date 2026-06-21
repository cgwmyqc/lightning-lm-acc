add_executable(run_frontend_offline
        run_frontend_offline.cc
)

target_link_libraries(run_frontend_offline
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(run_loop_offline
        run_loop_offline.cc
)

target_link_libraries(run_loop_offline
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(run_slam_offline
        run_slam_offline.cc
)

target_link_libraries(run_slam_offline
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(run_slam_online
        run_slam_online.cc
)

target_link_libraries(run_slam_online
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(run_loc_offline
        run_loc_offline.cc
)

target_link_libraries(run_loc_offline
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(run_loc_online
        run_loc_online.cc
)

target_link_libraries(run_loc_online
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(export_loc_golden_frame
        export_loc_golden_frame.cc
)

target_link_libraries(export_loc_golden_frame
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(test_ui
        test_ui.cc
)

target_link_libraries(test_ui
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(build_surfel_loc_golden
        build_surfel_loc_golden.cc
)

target_link_libraries(build_surfel_loc_golden
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(run_surfel_loc_golden_replay
        run_surfel_loc_golden_replay.cc
)

target_link_libraries(run_surfel_loc_golden_replay
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

add_executable(run_surfel_loc_xdma_golden
        run_surfel_loc_xdma_golden.cc
)

target_link_libraries(run_surfel_loc_xdma_golden
        ${PROJECT_NAME}.libs
        ${third_party_libs}
)

install(TARGETS run_slam_offline run_slam_online run_loc_offline run_loc_online
        export_loc_golden_frame build_surfel_loc_golden run_surfel_loc_golden_replay run_surfel_loc_xdma_golden
        DESTINATION lib/${PROJECT_NAME})
