%example to show how to use plot_stl
triangles = read_binary_stl_file('D638_TypeI.stl');
triangles = rotate_stl(triangles,'x',90);
plot_stl(triangles);