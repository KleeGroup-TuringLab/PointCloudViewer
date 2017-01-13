$fa=0.1;
$fn=128;

module evidement() {
 translate ([0,0,1]) {
    minkowski() {
            linear_extrude(height = 15, center = false, convexity = 10, twist = 0, slices = 40, scale = 1.0) {
                polygon(points=[[-18,45],[-5,150],[-5,45]]);
            }
        cylinder(r=4,h=1, center=false);
        }
    }
}

difference() {
    minkowski() {
        linear_extrude(height = 12, center = true, convexity = 10, twist = -fanrot, slices = 40, scale = 1.0) {
            // polygon(points=[[-15,0],[-15,40],[0,160],[15,40],[15,0]]);
            polygon(points=[[-20,0],[0,160],[20,0]]);
        }
    cylinder(r=10,h=15, center=true);
    }
    cube([100,75,23.3], center = true);
    translate([0,162,0]) {
        cube([8,8,100], center = true);
        //cylinder(r=5,h=60, center=true);
    }
    evidement();
    rotate([0,180,0]) { evidement(); }
    translate([0,0,-18]) { rotate([0,0,0]) { evidement(); } }
    translate([0,0,18]) { rotate([0,180,0]) { evidement(); } }
    
    scale([1,8,2]) 
        translate([0,12,14]) 
            rotate([0,90,0]) 
                cylinder(r=10,h=100, center=true);
    scale([1,8,2]) 
        translate([0,12,-14]) 
            rotate([0,90,0]) 
                cylinder(r=10,h=100, center=true);
}
