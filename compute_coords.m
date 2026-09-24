%Computes the vertex coordinates that describe a legal linkage configuration
%INPUTS:
%vertex_coords_guess: a column vector containing the (x,y) coordinates of every vertex
%                     these coords are just a GUESS! It's used to seed Newton's method
%leg_params: a struct containing the parameters that describe the linkage
%theta: the desired angle of the crank
%OUTPUTS:
%vertex_coords_root: a column vector containing the (x,y) coordinates of every vertex
%                    these coords satisfy all the kinematic constraints!

function vertex_coords_root = compute_coords(vertex_coords_guess, leg_params, theta)

    % Create a function handle that only depends on vertex_coords.
    % leg_params and theta are fixed by the anonymous function.
    fun = @(vertex_coords) linkage_error_func(vertex_coords, leg_params, theta);

    % Use the provided multidimensional Newton solver.
    [vertex_coords_root, exit_flag] = multi_newton_solver(fun, vertex_coords_guess);

    % Check if Newton's method converged.
    if exit_flag ~= 1
        warning('Newton solver did not converge. Exit flag = %d', exit_flag);
    end

end


%Error function that encodes all necessary linkage constraints
function error_vec = linkage_error_func(vertex_coords, leg_params, theta)

    distance_errors = link_length_error_func(vertex_coords, leg_params);
    coord_errors = fixed_coord_error_func(vertex_coords, leg_params, theta);

    error_vec = [distance_errors; coord_errors];

end


%Error function that encodes the link length constraints
function length_errors = link_length_error_func(vertex_coords, leg_params)

    % There are 10 links in the Strandbeest linkage
    num_links = leg_params.num_linkages;

    % Preallocate error vector
    length_errors = zeros(num_links,1);

    % Loop through every link
    for i = 1:num_links

        % Get the two vertices connected by this link
        vertex_a = leg_params.link_to_vertex_list(i,1);
        vertex_b = leg_params.link_to_vertex_list(i,2);

        % Get coordinates of vertex a
        xa = vertex_coords(2*vertex_a - 1);
        ya = vertex_coords(2*vertex_a);

        % Get coordinates of vertex b
        xb = vertex_coords(2*vertex_b - 1);
        yb = vertex_coords(2*vertex_b);

        % Desired length of this link
        d = leg_params.link_lengths(i);

        % Squared-distance constraint
        length_errors(i) = (xb-xa)^2 + (yb-ya)^2 - d^2;

    end

end


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