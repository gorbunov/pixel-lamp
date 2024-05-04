// single led section
base_side = 10;
total_height = 6;
separation_x = 1.6;
separation_y = 1.6;
base_shell_height = 0.4;
resistors_height = 1.6;
separation_z = total_height - base_shell_height;

// external_shell
shell_side = 4;
shell_height = 7;
additional_shell_width = shell_side - separation_y;
additional_shell_height = shell_side - total_height;

// slot def
cutout_size_x = base_side - separation_x;
cutout_size_y = base_side - separation_y;
cutout_depth = total_height - separation_z;

// screw_holes
screw_size = 2.5; // M2.5
screw_depth = 5;
screw_per_side = 5;

// sections repeat count
pattern_repeat_x = 16;
pattern_repeat_y = 16;

// internal_dimensions
led_section_width = base_side + separation_x;
led_section_height = base_side + separation_y;
internal_width = pattern_repeat_x * led_section_width + separation_x;
internal_height = pattern_repeat_y * led_section_height + separation_y;


module led_section() {
difference() {
cube([base_side, base_side, total_height]);
translate([0, 0, cutout_depth]) {
    cube([cutout_size_x, cutout_size_y, separation_z]);
    }
  translate([base_side / 3 - base_side / 12, 0, total_height - resistors_height]) {
    color("red") cube([base_side / 3, base_side, separation_z]);
 }

 }
}

module internal_section() {
for(ty=[0:pattern_repeat_y-1]) {
  for(tx=[0:pattern_repeat_x-1]) {
     translate([tx* base_side, ty * base_side, 0]) 
     led_section();
  }
}
// panel side enclosing
translate([-separation_x, -separation_y, 0]) {
    // bottom edge
    cube([(base_side * pattern_repeat_x) + separation_x, separation_y, total_height]);
    // left edge
    cube([separation_x, (base_side * pattern_repeat_y) + separation_y, total_height]);
}

}

module outer_shell() {
// outer shell
translate([-shell_side - separation_x, -shell_side - separation_y, 0]) {
 cube([shell_side, base_side * pattern_repeat_y + shell_side + separation_y, shell_height]);
 cube([base_side  * pattern_repeat_x + shell_side + separation_x, shell_side, shell_height]);
}

translate([base_side * pattern_repeat_x, -shell_side - separation_y, 0]) {
 cube([shell_side, base_side * pattern_repeat_y + shell_side* 2 + separation_y, shell_height]);
}
translate([-shell_side - separation_x, base_side * pattern_repeat_y, 0]) {
 cube([base_side * pattern_repeat_x + shell_side + separation_x, shell_side, shell_height]);
 }
 
}

module screw_hole() {
translate([0, 0, shell_height - screw_depth]) {
    #cylinder(h=screw_depth, d=screw_size, $fn=24);
    }
}

module shell() {

translate([shell_side+separation_x, shell_side+separation_y, 0]) {
internal_section();
color("aliceblue") outer_shell();
}
}
difference() {
shell();
translate([led_section_height-(screw_size+separation_x)/2, shell_side/2, 0]) {
for(tx=[0:pattern_repeat_x/led_per_screw -1]) {
    translate([tx*led_per_screw* (base_side), 0, 0]) {
    screw_hole();
    translate([0, internal_height-screw_size, 0]) {
    screw_hole();
    }
    }
}
}
}























