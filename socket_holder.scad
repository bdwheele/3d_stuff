$fn=64;

mask_depth = 5;
finger_spacing = 2;
finger_vspacing = 10;
size_height = 4;
size_offset = 2;
//size_font = "EuroStyle:style=Normal";
size_font = "DejaVu Sans";
size_depth = 1;

inch_sockets = [
    [
        ["1/4", "5/32", 11.5],
        ["1/4", "3/16", 11.5],
        ["1/4", "7/32", 11.5],
        ["1/4", "1/4", 11.5],
        ["1/4", "9/32", 11.5],
        ["1/4", "5/16", 12],
        ["1/4", "11/32", 12.8],
        ["1/4", "3/8", 13.9],
        ["1/4", "7/16", 15.7],
        ["1/4", "1/2", 17.3],
    ],
    [
        ["3/8", "3/8", 16.8],
        ["3/8", "7/16", 16.7],
        ["3/8", "1/2", 18.4],
        ["3/8", "9/16", 19.8],
        ["3/8", "5/8", 21.9],
        ["3/8", "11/16", 24.2],
        ["3/8", "3/4", 25.6],
    ],
    [
        ["3/8", "3/8", 16.6],
        ["3/8", "7/16", 16.7],
        ["3/8", "1/2", 17.7],
        ["3/8", "9/16", 19.8],
        ["3/8", "5/8", 21.5],
        ["3/8", "11/16", 23.3],
        ["3/8", "3/4", 25.3],
    ],
    [
        ["1/2", "13/16", 28.6],
        ["1/2", "7/8", 29.8],
        ["1/2", "15/16", 32],
        ["1/2", "1", 33.4],
    ]
];

metric_sockets = [
    [
        ["1/4", "4", 11.6],
        ["1/4", "5", 11.6],
        ["1/4", "5.5", 11.6],
        ["1/4", "6", 11.6],
        ["1/4", "7", 11.6],
        ["1/4", "8", 12],
        ["1/4", "9", 12.8],
        ["1/4", "10", 14],
        ["1/4", "11", 15.7],
        ["1/4", "12", 17.3],
    ],
    [
        ["3/8", "13", 16.5],
        ["3/8", "14", 19.7],
        ["3/8", "15", 20.7],
        ["3/8", "16", 21.9],
        ["3/8", "17", 23.6],
        ["3/8", "18", 24.3],
        ["3/8", "19", 25.5],
    ],
    [
        ["1/2", "21", 28.6],
        ["1/2", "22", 29.8],
        ["1/2", "23", 30.9],
        ["1/2", "24", 32],
    ]
];


common_sockets = [
    [
        ["1/4", "5/32", 11.5],
        ["1/4", "3/16", 11.5],
        ["1/4", "7/32", 11.5],
        ["1/4", "1/4", 11.5],
        ["1/4", "9/32", 11.5],
    
        ["1/4", "5/16", 12],
        ],[
        ["1/4", "11/32", 12.8],
        ["1/4", "3/8", 13.9],
        ["1/4", "7/16", 15.7],
        ["1/4", "1/2", 17.3],
    ],

    [
        ["1/4", "4", 11.6],
        ["1/4", "5", 11.6],
        ["1/4", "5.5", 11.6],
        ["1/4", "6", 11.6],
        ["1/4", "7", 11.6],
    
        ["1/4", "8", 12],
        ],[
        ["1/4", "9", 12.8],
        ["1/4", "10", 14],
        ["1/4", "11", 15.7],
        ["1/4", "12", 17.3],
    ],
];






/*
Mask for an individual socket (and label)
*/
module socket_mask(spec) {    
    translate([0, 0, 0]) {
        difference() {
            cylinder(d=spec[2], h=25);
            translate([0, 0, -0.01]) {
                if(spec[0] == "1/4") {
                    cylinder(d=6, h=8);
                } else if(spec[0] == "3/8") {
                    cylinder(d=9.2, h=11.5);
                } else if(spec[0] == "1/2") {
                    cylinder(d=12.4, h=15.3);
                } else {
                    echo("Bad socket hole specified");
                }
            }
        }
        translate([0, -((spec[2] / 2)  + size_offset), mask_depth - size_depth + 0.01]) {
            linear_extrude(height=size_depth) {
                text(spec[1], size_height, valign="top", halign="center", font=size_font);
            }
        }
    }
}

/* Lay out a complete set as a mask */
module set_mask(socket_set) {
    // get the max size for each thing in all rows
    ysizes = [for(r = 0; r < len(socket_set); r = r + 1) 
                max([for(c = 0; c < len(socket_set[r]); c = c + 1) 
                    socket_set[r][c][2] + finger_vspacing])];
    yoffsets = [for(a = 0, b = 0; a < len(ysizes); a = a + 1, b = b + ysizes[a]) b];
    echo(yoffsets);
    for(r = [0:len(socket_set) - 1]) {
        // get x offsets for everything in this row.
        xoffsets = [for(a = 0, b = 0; 
                        a < len(socket_set[r]); 
                        a = a + 1, b = b + socket_set[r][a][2] + finger_spacing) b];
        for(c = [0:len(socket_set[r]) - 1]) {
            translate([xoffsets[c], yoffsets[r], 0]) {
                socket_mask(socket_set[r][c]);
            }
        }        
    }
}






difference() {
    cube([170, 150, 6]);
    translate([17, 17, 1])
        set_mask(inch_sockets);
}


