%runs strandbeest simulation
function strandbeest_simulation()

    leg_params = define_leg_parameters();
    
    steps_per_cycle = 200;
    num_cycles = 3;
    tip_vertex_idx = 7;
   
    vertex_coords_guess = zeros(14, 1);
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

    % Set axis limits
    axis([-120 40 -130 60]);
    % Labels and title
    title('Strandbeest Leg Simulation With Tip Path','Interpreter','latex', 'FontSize',20);

    xlabel('$x$ (-)','Interpreter','latex', 'FontSize',16);

    ylabel('$y$ (-)', 'Interpreter','latex', 'FontSize',16);

   

    % calculate the leg tip path for one for cycle, do this before plotting
    % the rest of the leg so it overlays 
    overlay_guess = vertex_coords_guess;
    tip_path_x = zeros (steps_per_cycle + 1, 1);
    tip_path_y = zeros (steps_per_cycle + 1, 1);
    for k = 1:steps_per_cycle +1
        theta_k = 2*pi*(k-1)/steps_per_cycle;
        coords_k = compute_coords (overlay_guess, leg_params, theta_k);
        tip_path_x(k) = coords_k(2*tip_vertex_idx - 1);
        tip_path_y(k) = coords_k(2*tip_vertex_idx);
    end

    path_handle = plot (tip_path_x, tip_path_y, '--', 'Color','b', LineWidth= 1)

    
    % Initialize the drawing
    leg_drawing = initialize_leg_drawing(leg_params);


  


    % Create video
    fname = 'strandbeest_animation.avi';
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

        % Update linkage drawing
        update_leg_drawing(...
            vertex_coords_root, leg_drawing, leg_params);

        % Use current solution as next guess
        vertex_coords_guess = vertex_coords_root;

        % Update figure
        drawnow;

        % Capture current frame
        current_frame = getframe(fig1);

        % Write frame to video
        writeVideo(writerObj,current_frame);

    end

    % Close video
    close(writerObj);

end