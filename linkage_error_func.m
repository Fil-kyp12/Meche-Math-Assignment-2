%Error function that encodes all necessary linkage constraints
function error_vec = linkage_error_func(vertex_coords, leg_params, theta)

    distance_errors = link_length_error_func(vertex_coords, leg_params);
    coord_errors = fixed_coord_error_func(vertex_coords, leg_params, theta);

    error_vec = [distance_errors; coord_errors];

end
