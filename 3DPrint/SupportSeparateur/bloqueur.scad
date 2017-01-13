longueur= 50;

union() {
    difference() {
        cube([12,10,2], center=true);
        translate([0,-4,0])
            cube([6,12,4], center=true);
    }
    translate([0,5,1])
        cube([12,2,4], center=true);
    
}
