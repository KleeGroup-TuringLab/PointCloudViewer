$fn=128;
$fa=0.05;

output = 2;

module plug(diam, wall, ajust) {
    difference(){
        union() {
        cylinder(h=diam,d=diam*0.8);
        translate([0,0,diam*0.9])
            cylinder(h=diam,d1=diam+ajust,d2=diam*0.7);
        translate([0,0,2*diam*0.9])
            cylinder(h=diam,d1=diam,d2=diam*0.65);
        translate([0,0,3*diam*0.9])
            cylinder(h=diam,d1=diam-ajust,d2=diam*.6);
        }
        translate([0,0,-1])
        cylinder(h=5*diam,d=diam*0.7-2*wall);
    }
}

union(){
    // Outputs
    for (i=[0:1:output-1]) {
        translate([15*i, 0, -2]) plug(5, 0.8, 0.2);
    }
    // One input
    translate([15*(output-1)/2, 0, -8]) rotate([180, 0, 0]) plug(10, 1, 0.5);
    // Central bloc
    difference() {
        translate([-7.5,-10.5/2,-10]) cube([15*output,10.5,10]);
        // Outputs
        for (i=[0:1:output-1]) {
            translate([15*i, 0, -5]) cylinder(h=10,d=5*0.7-2*0.2);
        }
        // input
        translate([15*(output-1)/2, 0, -7]) rotate([180, 0, 0]) cylinder(h=4,d=10*0.8-2);
        // Central bloc
        translate([2-7.5,2-10.5/2,2-10]) cube([15*output-4,10.5-4,10-4]);
    }
}