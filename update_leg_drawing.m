%Updates the plot objects that visualize the leg linkage 
%for the current leg configuration 
%INPUTS: 
%complete_vertex_coords: a column vector containing the (x,y) coordinates of every vertex 
%leg_drawing: a struct containing all the plotting objects for the linkage 
%       leg_drawing.linkages is a cell array, where each element corresponds 
%       to a plot of a single link (excluding the crank) 
%       leg_drawing.crank is a plot of the crank link 
%       leg_drawing.vertices is a cell array, where each element corresponds 
%       to a plot of one of the vertices in the linkage 
function update_leg_drawing(complete_vertex_coords, leg_drawing, leg_params) 

    % Iterate through each link, and update corresponding link plot
    for linkage_index = 1:leg_params.num_linkages 
        
        % Get the two vertices connected by this link
        vertex_a = leg_params.link_to_vertex_list(linkage_index,1);
        vertex_b = leg_params.link_to_vertex_list(linkage_index,2);
        
        % Get x and y coordinates of vertex a
        xa = complete_vertex_coords(2*vertex_a - 1);
        ya = complete_vertex_coords(2*vertex_a);
        
        % Get x and y coordinates of vertex b
        xb = complete_vertex_coords(2*vertex_b - 1);
        yb = complete_vertex_coords(2*vertex_b);
        
        % Coordinates for the line segment
        line_x = [xa, xb];
        line_y = [ya, yb];
        
        set(leg_drawing.linkages{linkage_index},...
            'xdata',line_x,'ydata',line_y);  
    end 

    % Iterate through each vertex, and update corresponding vertex plot
    for vertex_index = 1:leg_params.num_vertices 
        
        % Get x and y coordinates of current vertex
        dot_x = complete_vertex_coords(2*vertex_index - 1);
        dot_y = complete_vertex_coords(2*vertex_index);
        
        set(leg_drawing.vertices{vertex_index},...
            'xdata',dot_x,'ydata',dot_y);  
    end 

    % The crank goes from vertex 0 to vertex 1.
    % Vertex 0 is fixed at leg_params.vertex_pos0.
    crank_x = [leg_params.vertex_pos0(1), complete_vertex_coords(1)];
    crank_y = [leg_params.vertex_pos0(2), complete_vertex_coords(2)];
    
    set(leg_drawing.crank,...
        'xdata',crank_x,'ydata',crank_y); 
end