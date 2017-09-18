$fa=0.01;
$fn=128;

difference() {
    minkowski() {
        union() {
            // Air comprimé
            cylinder(h=4.8,d=9,center=true);
            // Cable électrique
            translate([2+(9+7)/2,(7-9)/2,0])
                cylinder(h=4.8,d=7,center=true);
            // Colson lubrification
            translate([-2-(9+5)/2,(5-9)/2,0])
            union() {
                difference() {
                    cylinder(h=3,d=5,center=true);
                    cylinder(h=5  ,d=1.8,center=true);
                    translate([-4,0,-2.5]) cube([8,4,5]);
                    translate([-4,-4,-2.5]) cube([4,8,5]);
                }
                translate([1.7,1,0]) cube([1.6,2,3], center=true);
                translate([-1,-1.7,0]) cube([2.3,1.6,3], center=true);
            }
            // Colson fixation aux tubes
            translate([0,-2-9/2,0])
                cube([5*2+5+7+9-2, 1.4, 4.8], center=true);
        }        
        cylinder (r=1.4, h=2.4, center=true);
    }
    union() {
        // Air comprimé
        cylinder(h=10,d=9,center=true);
        // Cable électrique
        translate([2+(9+7)/2,(7-9)/2,0])
            cylinder(h=10,d=7,center=true);
        // Colson lubrification
        translate([-2-(9+5)/2,(5-9)/2,0])
        union() {
            difference() {
                cylinder(h=3,d=5,center=true);
                cylinder(h=5  ,d=1.8,center=true);
                translate([-4,0,-2.5]) cube([8,4,5]);
                translate([-4,-4,-2.5]) cube([4,8,5]);
            }
            translate([1.7,2,0]) cube([1.6,4,3], center=true);
            translate([-2,-1.7,0]) cube([4,1.6,3], center=true);
        }
        // Colson fixation aux tubes
        translate([0,-2-9/2,0])
            cube([5*2+5+7+9+4, 1.5, 3], center=true);
    }   
}

/* */