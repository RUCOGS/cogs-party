shader_set(h_rainbow_shader);
shader_set_uniform_f(shader_get_uniform(h_rainbow_shader, "u_strength"), 1);
shader_set_uniform_f(shader_get_uniform(h_rainbow_shader, "u_speed"), 0.1);
shader_set_uniform_f(shader_get_uniform(h_rainbow_shader, "u_angle"), 45);
shader_set_uniform_f(shader_get_uniform(h_rainbow_shader, "u_scale"), 1.156);
shader_set_uniform_f(shader_get_uniform(h_rainbow_shader, "u_darken"), 0.6);
shader_set_uniform_f(shader_get_uniform(h_rainbow_shader, "u_time"), current_time / 1000);

draw_self();

shader_reset();