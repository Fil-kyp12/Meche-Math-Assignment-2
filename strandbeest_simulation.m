%runs strandbeest simulation
function strandbeest_simulation()

    leg_params = define_leg_parameters();

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

    % Initialize the drawing
    leg_drawing = initialize_leg_drawing(leg_params);

    % Create video
    fname = 'strandbeest_animation.avi';
    writerObj = VideoWriter(fname);
    open(writerObj);

    % Number of simulation steps
    num_steps = 200;

    % Loop through crank angles
    for step = 1:num_steps

        % Current crank angle
        theta = 2*pi*(step-1)/num_steps;

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