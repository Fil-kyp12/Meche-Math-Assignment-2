%Compares two ways of computing the leg tip velocity dV/dtheta
%Method 1: linear algebra, solve M*dV/dtheta = B (compute_velocities)
%Method 2: finite differences of the leg tip trajectory
%          (compute_coords wrapped as a function of theta only,
%           then passed to approximate_jacobian)
%Saves the plot as a high resolution png and pdf
function compare_tip_velocity()

    leg_params = define_leg_parameters();
    tip_vertex_idx = 7;

    % crank angles to evaluate
    num_points = 200;
    theta_list = linspace(0, 2*pi, num_points);

    % initial guess (same as the simulation)
    vertex_coords_guess = [...
        [   0;   50];... %vertex 1 guess
        [ -50;    0];... %vertex 2 guess
        [ -50;   50];... %vertex 3 guess
        [-100;    0];... %vertex 4 guess
        [-100;  -50];... %vertex 5 guess
        [ -50;  -50];... %vertex 6 guess
        [ -50; -100]...  %vertex 7 guess
        ];

    % storage for tip velocities from each method
    dxdtheta_linalg = zeros(num_points,1);
    dydtheta_linalg = zeros(num_points,1);
    dxdtheta_findiff = zeros(num_points,1);
    dydtheta_findiff = zeros(num_points,1);

    for k = 1:num_points
        theta = theta_list(k);

        % legal linkage configuration at this crank angle
        vertex_coords = compute_coords(vertex_coords_guess, leg_params, theta);

        % Method 1: linear algebra
        dVdtheta_1 = compute_velocities(vertex_coords, leg_params, theta);

        % Method 2: finite differences
        % wrap compute_coords so it only depends on theta
        % (seeded with the current legal configuration so the solver
        % stays on the same linkage shape at theta +/- h)
        coords_of_theta = @(th) compute_coords(vertex_coords, leg_params, th);

        % input is 1 number (theta), output is 14 coords,
        % so the "Jacobian" is a 14x1 column: dV/dtheta
        dVdtheta_2 = approximate_jacobian(coords_of_theta, theta);

        % keep only the leg tip entries
        dxdtheta_linalg(k) = dVdtheta_1(2*tip_vertex_idx - 1);
        dydtheta_linalg(k) = dVdtheta_1(2*tip_vertex_idx);
        dxdtheta_findiff(k) = dVdtheta_2(2*tip_vertex_idx - 1);
        dydtheta_findiff(k) = dVdtheta_2(2*tip_vertex_idx);

        % use this solution as the next guess
        vertex_coords_guess = vertex_coords;
    end

    % print the largest difference between the methods
    fprintf('Max |difference| in dx_tip/dtheta: %.2e\n', ...
            max(abs(dxdtheta_linalg - dxdtheta_findiff)));
    fprintf('Max |difference| in dy_tip/dtheta: %.2e\n', ...
            max(abs(dydtheta_linalg - dydtheta_findiff)));

    % ------------------------------------------------------------
    % Plotting
    % ------------------------------------------------------------
    fig1 = figure(2);
    set(fig1,'units','pixels','position',[100 100 1100 900]);

    % tick marks at multiples of pi/2
    tick_values = 0:pi/2:2*pi;
    tick_labels = {'$0$','$\pi/2$','$\pi$','$3\pi/2$','$2\pi$'};

    legend_labels = {'Method 1: linear algebra', ...
                     'Method 2: finite differences'};

    % ---- dx_tip/dtheta ----
    subplot(2,1,1);
    hold on; grid on; box on;
    % solid line first, dashed line on top so both are visible
    plot(theta_list, dxdtheta_linalg, '-', 'Color', 'b', 'LineWidth', 3);
    plot(theta_list, dxdtheta_findiff, '--', 'Color', 'r', 'LineWidth', 2);
    xlim([0 2*pi]);
    set(gca,'XTick',tick_values,'XTickLabel',tick_labels, ...
        'TickLabelInterpreter','latex','FontSize',14);
    title('Leg Tip Horizontal Velocity vs. Crank Angle', ...
          'Interpreter','latex','FontSize',18);
    xlabel('Crank angle $\theta$ (rad)','Interpreter','latex','FontSize',16);
    ylabel('$dx_{tip}/d\theta$ (-)','Interpreter','latex','FontSize',16);
    legend(legend_labels,'Interpreter','latex','FontSize',13,'Location','southeast');

    % ---- dy_tip/dtheta ----
    subplot(2,1,2);
    hold on; grid on; box on;
    plot(theta_list, dydtheta_linalg, '-', 'Color', 'b', 'LineWidth', 3);
    plot(theta_list, dydtheta_findiff, '--', 'Color', 'r', 'LineWidth', 2);
    xlim([0 2*pi]);
    set(gca,'XTick',tick_values,'XTickLabel',tick_labels, ...
        'TickLabelInterpreter','latex','FontSize',14);
    title('Leg Tip Vertical Velocity vs. Crank Angle', ...
          'Interpreter','latex','FontSize',18);
    xlabel('Crank angle $\theta$ (rad)','Interpreter','latex','FontSize',16);
    ylabel('$dy_{tip}/d\theta$ (-)','Interpreter','latex','FontSize',16);
    legend(legend_labels,'Interpreter','latex','FontSize',13,'Location','southwest');

    % save high resolution copies (not a screenshot)
    exportgraphics(fig1, 'tip_velocity_comparison.png', 'Resolution', 300);
    exportgraphics(fig1, 'tip_velocity_comparison.pdf', 'ContentType', 'vector');

end
