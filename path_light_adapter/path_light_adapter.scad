include <BOSL/constants.scad>
use <BOSL/masks.scad>

$fn=64;

// Female end of solar light
sol_dia = 21.3;
sol_depth = 20;
sol_web = 2;


// Diameter of PVC pipe
pipe_dia = 26.8;  // measured from pipe.
pipe_overlap = 20;
pipe_thick = 2;

// The solar light end
translate([0, 0, (sol_depth/2) - 0.01])
    difference() {
        union() {
            cube([sol_dia, sol_web, sol_depth], center=true);
            cube([sol_web, sol_dia, sol_depth], center=true);
        }
        translate([0, 0, sol_depth/2])
            chamfer_cylinder_mask(r=sol_dia/2, chamfer=sol_web);
    }

translate([0, 0, -pipe_overlap])
// The PVC Pipe end
difference() {
    cylinder(d=pipe_dia + 2*pipe_thick, h=pipe_overlap + pipe_thick);
    translate([0, 0, pipe_overlap + pipe_thick])
        fillet_cylinder_mask(r=(pipe_dia + 2*pipe_thick)/2, fillet=pipe_thick);
    
    // The PVC Pipe itself
    translate([0, 0, -0.01])
    difference() {
        cylinder(d=pipe_dia, h=pipe_overlap - pipe_thick);
        translate([0, 0, pipe_overlap - pipe_thick])
        fillet_cylinder_mask(r=pipe_dia/2, fillet=pipe_thick);
    }
}
