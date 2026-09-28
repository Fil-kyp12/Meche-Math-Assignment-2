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