$fa=0.01;
$fn=128;

difference() {
    minkowski() {
        union() {
            cylinder(h=4.8,d=9,center=true);
            translate([2+(9+7)/2,(7-9)/2,0])
                cylinder(h=4.8,d=7,center=true);
            translate([-2-(9+5)/2,(5-9)/2,0])
                cylinder(h=4.8,d=5,center=true);
            translate([0,-2-9/2,0])
                cube([5*2+5+7+9-2, 1.4, 4.8], center=true);
        }
        cylinder (r=1.4, h=2.4, center=true);
    }
    union() {
        cylinder(h=10,d=9,center=true);
        translate([2+(9+7)/2,(7-9)/2,0])
            cylinder(h=10,d=7,center=true);
        translate([-2-(9+5)/2,(5-9)/2,0])
            cylinder(h=10,d=5,center=true);
        translate([0,-2-9/2,0])
            cube([5*2+5+7+9+4, 1.5, 3], center=true);
    }   
}