%Error function that encodes the fixed vertex constraints
function coord_errors = fixed_coord_error_func(vertex_coords, leg_params, theta)

    % Preallocate four coordinate errors:
    % [x1-x1_desired;
    %  y1-y1_desired;
    %  x2-x2_desired;
    %  y2-y2_desired]
    coord_errors = zeros(4,1);

    % ---------------------------------------------------------
    % Vertex 1: crank endpoint
    % ---------------------------------------------------------

    x1_desired = leg_params.vertex_pos0(1) + ...
                 leg_params.crank_length*cos(theta);

    y1_desired = leg_params.vertex_pos0(2) + ...
                 leg_params.crank_length*sin(theta);

    % Current coordinates of vertex 1
    x1 = vertex_coords(1);
    y1 = vertex_coords(2);

    % Errors for vertex 1
    coord_errors(1) = x1 - x1_desired;
    coord_errors(2) = y1 - y1_desired;


    % ---------------------------------------------------------
    % Vertex 2: fixed point
    % ---------------------------------------------------------

    x2 = vertex_coords(3);
    y2 = vertex_coords(4);

    % Desired coordinates of vertex 2
    x2_desired = leg_params.vertex_pos2(1);
    y2_desired = leg_params.vertex_pos2(2);

    % Errors for vertex 2
    coord_errors(3) = x2 - x2_desired;
    coord_errors(4) = y2 - y2_desired;

end