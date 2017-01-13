longueur= 56;
tolerance= -0.2;

difference() {
    cube([8+tolerance,longueur,8+tolerance]);
    translate([17+tolerance,(longueur-28)/2,0]) cube([20,3,20], center = true);
    translate([17+tolerance,(longueur+28)/2,0]) cube([20,3,20], center = true);
    translate([-9,(longueur-28)/2,0]) cube([20,3,20], center = true);
    translate([-9,(longueur+28)/2,0]) cube([20,3,20], center = true);
    
    translate([0,(longueur+27)/2+9,10])
    rotate([0,90,0])
    cylinder(r=4,h=20, center=true);

    translate([0,(longueur-27)/2-9,10])
    rotate([0,90,0])
    cylinder(r=4,h=20, center=true);
}