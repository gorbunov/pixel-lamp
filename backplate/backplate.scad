led_count_side = 16;
plate_size = 10;
plate_wall = 1.6;

shell_side = 4;
additional_shell = 2;

total_backplate_height = 4;
inner_backplate_height = 3;

screw_size = 2.5;
screws_per_side = 5;
$fn = 24;
screw_head_dk = 5;
screw_head_depth = 2.5;

wires_slot_height = 12;
wires_slot_width = 100;
wires_top_edge_offset = 45;

inner_size = (plate_size) * led_count_side + plate_wall;
total_backplate_size = inner_size + shell_side * 2;

difference() {
    backplate();
    union() {
        backplate_cutouts();
        screw_holes();
    }
}

module backplate_cutouts() {
    translate([(total_backplate_size - wires_slot_width)/2, total_backplate_size - wires_top_edge_offset, 0]) {
        color("orange") cube([wires_slot_width,wires_slot_height, total_backplate_height]);
    }
}

module backplate() {
    difference() {
        union() {
            cube([total_backplate_size, total_backplate_size, total_backplate_height]);
            translate([-additional_shell, -additional_shell, 0]) {
                color("aliceblue") cube([total_backplate_size + additional_shell * 2, total_backplate_size + additional_shell * 2, total_backplate_height]);
            }
        }
        translate([shell_side + additional_shell, shell_side + additional_shell, total_backplate_height - inner_backplate_height]) {
            cube_cutouts();
        }
    }
}

module cube_cutout(cutout_side) {
    cube([cutout_side, cutout_side, inner_backplate_height]);
}

module cube_cutouts() {
    total_cutout_side = inner_size - additional_shell * 2;
    cube_cutout(total_cutout_side);
}

module screw_hole() {
    color("green") cylinder(d = screw_size, total_backplate_height);
    translate([0, 0, total_backplate_height - screw_head_depth]) {
        color("blue") cylinder(d2 = screw_head_dk, d1 = screw_size, screw_head_depth);
    }
}

screw_offset = (inner_size + shell_side) / screws_per_side;

module screw_holes() {
    translate([shell_side / 2, shell_side / 2, 0]) {
        for (scx = [0:screws_per_side]) {
            translate([scx * screw_offset, 0, 0]) {
                screw_hole();
            }
            translate([scx * screw_offset, inner_size + shell_side, 0]) {
                screw_hole();
            }

            translate([0, scx * screw_offset, 0]) {
                screw_hole();
            }

            translate([inner_size + shell_side, scx * screw_offset, 0]) {
                screw_hole();
            }

        }
    }
}
