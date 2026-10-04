%runs strandbeest simulation with tip path and tip velocity overlays
function strandbeest_simulation_with_velo()

    leg_params = define_leg_parameters();

    steps_per_cycle = 200;
    num_cycles = 3;
    tip_vertex_idx = 7;

    % scale factor for the velocity arrow so it is visible on the plot
    velocity_scale = 0.5;

    % Column vector of initial guesses
    % in form: [x1;y1;x2;y2;...;xn;yn]
    vertex_coords_guess = [...
        [   0;   50];... %vertex 1 guess
        [ -50;    0];... %vertex 2 guess
        [ -50;   50];... %vertex 3 guess
        [-100;    0];... %vertex 4 guess
        [-100;  -50];... %vertex 5 guess
        [ -50;  -50];... %vertex 6 guess
        [ -50; -100]...  %vertex 7 guess
        ];

    % Create figure
    fig1 = figure(1);

    % Make the figure high quality
    set(fig1,'units','pixels','position',[0 0 1440 1080]);

    % Set up plotting
    hold on;
    axis equal;
    grid on;

    % Set axis limits (fixed for the whole animation)
    axis([-120 30 -110 55]);

    % Labels and title
    title('Strandbeest Leg Simulation With Tip Path and Tip Velocity',...
          'Interpreter','latex','FontSize',20);
    xlabel('$x$ (-)','Interpreter','latex','FontSize',16);
    ylabel('$y$ (-)','Interpreter','latex','FontSize',16);

    % LaTeX for the axis numbers too
    set(gca,'TickLabelInterpreter','latex','FontSize',14);

    % calculate the leg tip path for one full cycle, do this before plotting
    % the rest of the leg so the leg is drawn on top of it
    path_guess = vertex_coords_guess;
    tip_path_x = zeros(steps_per_cycle + 1, 1);
    tip_path_y = zeros(steps_per_cycle + 1, 1);
    for k = 1:steps_per_cycle + 1
        theta_k = 2*pi*(k-1)/steps_per_cycle;
        coords_k = compute_coords(path_guess, leg_params, theta_k);
        tip_path_x(k) = coords_k(2*tip_vertex_idx - 1);
        tip_path_y(k) = coords_k(2*tip_vertex_idx);
        path_guess = coords_k;
    end

    path_handle = plot(tip_path_x, tip_path_y, '--', 'Color', 'b', 'LineWidth', 1.5);

    % Initialize the leg drawing
    leg_drawing = initialize_leg_drawing(leg_params);

    % Initialize the velocity arrow (the 0 turns off quiver's auto scaling)
    velocity_handle = quiver(0, 0, 0, 0, 0, 'Color', [0 0.6 0], ...
                             'LineWidth', 2.5, 'MaxHeadSize', 0.8);

    % Legend
    legend([path_handle, velocity_handle], ...
           {'Leg tip path (one cycle)', ...
            ['Leg tip velocity $d\vec{V}_7/d\theta$ (scaled by ', num2str(velocity_scale), ')']}, ...
           'Interpreter','latex','FontSize',14,'Location','northwest');

    % Create video
    fname = 'strandbeest_velocity_animation.avi';
    writerObj = VideoWriter(fname);
    open(writerObj);

    % Number of simulation steps
    num_steps = num_cycles*steps_per_cycle;

    % Loop through crank angles
    for step = 1:num_steps

        % Current crank angle
        theta = 2*pi*(step-1)/steps_per_cycle;

        % Compute linkage configuration
        vertex_coords_root = compute_coords(...
            vertex_coords_guess, leg_params, theta);

        % Compute the theta derivatives of every vertex coordinate
        dVdtheta = compute_velocities(vertex_coords_root, leg_params, theta);

        % Pull out the leg tip position and velocity
        tip_x = vertex_coords_root(2*tip_vertex_idx - 1);
        tip_y = vertex_coords_root(2*tip_vertex_idx);
        tip_vx = dVdtheta(2*tip_vertex_idx - 1);
        tip_vy = dVdtheta(2*tip_vertex_idx);

        % Update linkage drawing
        update_leg_drawing(vertex_coords_root, leg_drawing, leg_params);

        % Update velocity arrow (starts at the tip, scaled to be visible)
        set(velocity_handle, 'XData', tip_x, 'YData', tip_y, ...
            'UData', velocity_scale*tip_vx, 'VData', velocity_scale*tip_vy);

        % Use current solution as next guess
        vertex_coords_guess = vertex_coords_root;

        % Update figure
        drawnow;

        % Capture current frame and write it to the video
        current_frame = getframe(fig1);
        writeVideo(writerObj,current_frame);

    end

    % Close video
    close(writerObj);

end
