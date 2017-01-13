longueur= 50;

difference() {
    cube([7.9,longueur,7.9]);
    translate([17,(longueur-27)/2,0]) cube([20,3,20], center = true);
    translate([17,(longueur+27)/2,0]) cube([20,3,20], center = true);
    translate([-9,(longueur-27)/2,0]) cube([20,3,20], center = true);
    translate([-9,(longueur+27)/2,0]) cube([20,3,20], center = true);
    
    translate([0,(longueur+27)/2+7,10])
    rotate([0,90,0])
    cylinder(r=4,h=20, center=true);

    translate([0,(longueur-27)/2-7,10])
    rotate([0,90,0])
    cylinder(r=4,h=20, center=true);
}