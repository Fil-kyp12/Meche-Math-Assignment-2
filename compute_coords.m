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

    % Solver settings: the errors are squared lengths (~1000s), so rounding
    % error alone is ~1e-12 and the default 1e-14 tolerance can never be met
    solver_params = struct();
    solver_params.ftol = 1e-10;
    solver_params.dxmin = 1e-10;

    % Use the provided multidimensional Newton solver.
    [vertex_coords_root, exit_flag] = multi_newton_solver(fun, vertex_coords_guess, solver_params);

    % Check if Newton's method converged.
    if exit_flag ~= 1
        warning('Newton solver did not converge. Exit flag = %d', exit_flag);
    end

end
